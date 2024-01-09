import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/datasource/remote/deals/deals_remote_data_source.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_item_model.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_items_response_model.dart';
import 'package:netzoon/data/models/deals/deals_response/deals_response_model.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';
import 'package:netzoon/injection_container.dart';

class DealsRepositoryImpl implements DealsRepository {
  final DealsRemoteDataSource dealsRemoteDataSource;
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDatasource local;
  DealsRepositoryImpl({
    required this.dealsRemoteDataSource,
    required this.networkInfo,
    required this.authRemoteDataSource,
    required this.local,
  });
  @override
  Future<Either<Failure, DealsResponse>> getDealsCategories() async {
    try {
      if (await networkInfo.isConnected) {
        final dealsCat = await dealsRemoteDataSource.getDealsCategories();
        return Right(dealsCat.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DealsItemsResponse>> getDealsByCategory({
    required String category,
    required String country,
    String? companyName,
    int? minPrice,
    int? maxPrice,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final dealsItem = await dealsRemoteDataSource.getDealsByCategory(
            country, category, companyName, minPrice, maxPrice);
        return Right(dealsItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(EmpltyDataFailure());
    }
  }

  @override
  Future<Either<Failure, DealsItemsResponse>> getDealsItems(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final dealItem = await dealsRemoteDataSource.getDealsItems(country);
        return Right(dealItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addDeal({
    required String owner,
    required String name,
    required String companyName,
    required File dealImage,
    required int prevPrice,
    required int currentPrice,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    required String category,
    required String country,
    required String description,
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
            MapEntry('name', name),
            MapEntry('companyName', companyName),
            MapEntry('prevPrice', prevPrice.toString()),
            MapEntry('currentPrice', currentPrice.toString()),
            MapEntry('startDate', startDate.toString()),
            MapEntry('endDate', endDate.toString()),
            MapEntry('location', location),
            MapEntry('category', category),
            MapEntry('country', country),
            MapEntry('description', description),
          ]);
          // ignore: unnecessary_null_comparison
          if (dealImage != null) {
            String fileName = 'image.jpg';
            formData.files.add(MapEntry(
              'dealImage',
              await MultipartFile.fromFile(
                dealImage.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }
          final user2 = local.getSignedInUser();
          Response response = await dio.post(
            'https://www.netzoonback.siidevelopment.com//deals/addDeal',
            data: formData,
            options:
                Options(headers: {'Authorization': 'Bearer ${user2?.token}'}),
          );
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
  Future<Either<Failure, DealsItems>> getDealById({required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final deal = await dealsRemoteDataSource.getDealById(id);

        return Right(deal.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteDeal({required String id}) async {
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
          final result = await dealsRemoteDataSource.deleteDeal(id);
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
  Future<Either<Failure, String>> editDeal({
    required String id,
    required String name,
    required String companyName,
    required File? dealImage,
    required int prevPrice,
    required int currentPrice,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    required String category,
    required String country,
    required String description,
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
            MapEntry('id', id),
            MapEntry('name', name),
            MapEntry('companyName', companyName),
            MapEntry('prevPrice', prevPrice.toString()),
            MapEntry('currentPrice', currentPrice.toString()),
            MapEntry('startDate', startDate.toString()),
            MapEntry('endDate', endDate.toString()),
            MapEntry('location', location.toString()),
            MapEntry('category', category.toString()),
            MapEntry('country', country.toString()),
            MapEntry('description', description),
          ]);
          if (dealImage != null) {
            String fileName = 'image.jpg';
            formData.files.add(MapEntry(
              'dealImage',
              await MultipartFile.fromFile(
                dealImage.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }
          final user2 = local.getSignedInUser();

          Response response = await dio.put(
            'https://www.netzoonback.siidevelopment.com/deals/$id',
            data: formData,
            options:
                Options(headers: {'Authorization': 'Bearer ${user2?.token}'}),
          );
          return Right(response.data);
          // final news = await newsRemoteDataSourse.editNews(
          //     id, title, description, image, creator);
          // return Right(news.toDomain());
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
  Future<Either<Failure, List<DealsItems>>> getUserDeals(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await dealsRemoteDataSource.getUserDeals(userId);
        return Right(result.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
