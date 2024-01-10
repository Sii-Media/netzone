import 'dart:io';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/advertisements/ads_remote_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/models/advertisements/advertisements/advertiement_model.dart';
import 'package:netzoon/data/models/advertisements/advertising/advertising_model.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/injection_container.dart';
import 'package:share_plus/share_plus.dart';

class AdvertismentRepositoryImpl implements AdvertismentRepository {
  final AdvertismentRemotDataSource advertismentRemotDataSource;
  final NetworkInfo networkInfo;
  final AuthLocalDatasource local;
  final AuthRemoteDataSource authRemoteDataSource;
  AdvertismentRepositoryImpl({
    required this.local,
    required this.advertismentRemotDataSource,
    required this.networkInfo,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, Advertising>> getAllAds({
    String? owner,
    int? priceMin,
    int? priceMax,
    bool? purchasable,
    String? year,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getAllAdvertisment(
          owner,
          priceMin,
          priceMax,
          purchasable,
          year,
        );

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Advertising>> getAdvertisementByType(
      {required String userAdvertisingType}) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource
            .getAdvertisementByType(userAdvertisingType);

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      // print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addAdvertisement({
    required String owner,
    required String advertisingTitle,
    required String advertisingStartDate,
    required String advertisingEndDate,
    required String advertisingDescription,
    required File image,
    required String advertisingYear,
    required String advertisingLocation,
    required double advertisingPrice,
    required String advertisingType,
    List<XFile>? advertisingImageList,
    File? video,
    required bool purchasable,
    String? type,
    String? category,
    String? color,
    bool? guarantee,
    String? contactNumber,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
          FormData formData = FormData();
          formData.fields.addAll([
            MapEntry('owner', owner),
            MapEntry('advertisingTitle', advertisingTitle),
            MapEntry('advertisingStartDate', advertisingStartDate),
            MapEntry('advertisingEndDate', advertisingEndDate),
            MapEntry('advertisingDescription', advertisingDescription),
            MapEntry('advertisingYear', advertisingYear),
            MapEntry('advertisingLocation', advertisingLocation),
            MapEntry('advertisingPrice', advertisingPrice.toString()),
            MapEntry('advertisingType', advertisingType),
            MapEntry('purchasable', purchasable.toString()),
          ]);
          if (type != null) {
            formData.fields.add(
              MapEntry('type', type),
            );
          }
          if (category != null) {
            formData.fields.add(
              MapEntry('category', category),
            );
          }
          if (color != null) {
            formData.fields.add(
              MapEntry('color', color),
            );
          }
          if (guarantee != null) {
            formData.fields.add(
              MapEntry('guarantee', guarantee.toString()),
            );
          }
          if (contactNumber != null) {
            formData.fields.add(
              MapEntry('contactNumber', contactNumber),
            );
          }
          // ignore: unnecessary_null_comparison
          if (image != null) {
            String fileName = 'image.jpg';
            formData.files.add(MapEntry(
              'image',
              await MultipartFile.fromFile(
                image.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }

          if (advertisingImageList != null && advertisingImageList.isNotEmpty) {
            for (int i = 0; i < advertisingImageList.length; i++) {
              String fileName = 'image$i.jpg';
              File file = File(advertisingImageList[i].path);
              formData.files.add(MapEntry(
                'advertisingImageList',
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType('image', 'jpeg'),
                ),
              ));
            }
          }

          if (video != null) {
            String fileName = 'video.mp4';
            formData.files.add(MapEntry(
              'video',
              await MultipartFile.fromFile(
                video.path,
                filename: fileName,
                contentType: MediaType('video', 'mp4'),
              ),
            ));
          }
          final user2 = local.getSignedInUser();
          Response response = await dio.post(
            'https://www.netzoonback.siidevelopment.com/advertisements/createAds',
            data: formData,
            options:
                Options(headers: {'Authorization': 'Bearer ${user2?.token}'}),
          );
          // Handle the response as needed
          if (response.statusCode == 201) {
            return Right(response.data);
          } else {
            return Left(ServerFailure());
          }
        } else {
          return Left(CredintialFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Advertisement>> getAdsById(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getAdsById(id);

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Advertising>> getUserAds(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getUserAds(userId);

        return Right(ads.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteAdvertisement(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            final dio = sl<Dio>();
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
          final result =
              await advertismentRemotDataSource.deleteAdvertisement(id);
          return Right(result);
        } else {
          return Left(CredintialFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editAdvertisement(
      {required String id,
      required String advertisingTitle,
      required String advertisingStartDate,
      required String advertisingEndDate,
      required String advertisingDescription,
      required File? image,
      required String advertisingYear,
      required String advertisingLocation,
      required double advertisingPrice,
      required String advertisingType,
      List<XFile>? advertisingImageList,
      File? video,
      required bool purchasable,
      String? type,
      String? category,
      String? color,
      bool? guarantee,
      String? contactNumber}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }

          FormData formData = FormData();
          formData.fields.addAll([
            MapEntry('advertisingTitle', advertisingTitle),
            MapEntry('advertisingStartDate', advertisingStartDate),
            MapEntry('advertisingEndDate', advertisingEndDate),
            MapEntry('advertisingDescription', advertisingDescription),
            MapEntry('advertisingYear', advertisingYear),
            MapEntry('advertisingLocation', advertisingLocation),
            MapEntry('advertisingPrice', advertisingPrice.toString()),
            MapEntry('advertisingType', advertisingType),
            MapEntry('purchasable', purchasable.toString()),
          ]);
          if (type != null) {
            formData.fields.add(
              MapEntry('type', type),
            );
          }
          if (category != null) {
            formData.fields.add(
              MapEntry('category', category),
            );
          }
          if (color != null) {
            formData.fields.add(
              MapEntry('color', color),
            );
          }
          if (guarantee != null) {
            formData.fields.add(
              MapEntry('guarantee', guarantee.toString()),
            );
          }
          if (contactNumber != null) {
            formData.fields.add(
              MapEntry('contactNumber', contactNumber),
            );
          }
          // ignore: unnecessary_null_comparison
          if (image != null) {
            String fileName = 'image.jpg';
            formData.files.add(MapEntry(
              'image',
              await MultipartFile.fromFile(
                image.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }

          if (advertisingImageList != null && advertisingImageList.isNotEmpty) {
            for (int i = 0; i < advertisingImageList.length; i++) {
              String fileName = 'image$i.jpg';
              File file = File(advertisingImageList[i].path);
              formData.files.add(MapEntry(
                'advertisingImageList',
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType('image', 'jpeg'),
                ),
              ));
            }
          }

          if (video != null) {
            String fileName = 'video.mp4';
            formData.files.add(MapEntry(
              'video',
              await MultipartFile.fromFile(
                video.path,
                filename: fileName,
                contentType: MediaType('video', 'mp4'),
              ),
            ));
          }
          final user2 = local.getSignedInUser();
          Response response = await dio.put(
            'https://www.netzoonback.siidevelopment.com/advertisements/$id',
            data: formData,
            options:
                Options(headers: {'Authorization': 'Bearer ${user2?.token}'}),
          );
          // Handle the response as needed
          if (response.statusCode == 200) {
            return Right(response.data);
          } else {
            return Left(ServerFailure());
          }
        } else {
          return Left(CredintialFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addAdsVisitor(
      {required String adsId, required String viewerUserId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await advertismentRemotDataSource.addAdsVisitor(
            adsId, viewerUserId);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
