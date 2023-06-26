import 'dart:io';

import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/advertisements/ads_remote_data_source.dart';
import 'package:netzoon/data/models/advertisements/advertisements/advertiement_model.dart';
import 'package:netzoon/data/models/advertisements/advertising/advertising_model.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class AdvertismentRepositoryImpl implements AdvertismentRepository {
  final AdvertismentRemotDataSource advertismentRemotDataSource;
  final NetworkInfo networkInfo;

  AdvertismentRepositoryImpl({
    required this.advertismentRemotDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Advertising>> getAllAds() async {
    try {
      if (await networkInfo.isConnected) {
        final ads = await advertismentRemotDataSource.getAllAdvertisment();

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
  Future<Either<Failure, String>> addAdvertisement(
      {required String advertisingTitle,
      required String advertisingStartDate,
      required String advertisingEndDate,
      required String advertisingDescription,
      required File image,
      required String advertisingCountryAlphaCode,
      required String advertisingBrand,
      required String advertisingYear,
      required String advertisingLocation,
      required double advertisingPrice,
      required String advertisingType}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData.fromMap({
          'advertisingTitle': advertisingTitle,
          'advertisingStartDate': advertisingStartDate,
          'advertisingEndDate': advertisingEndDate,
          'advertisingDescription': advertisingDescription,
          'image': await MultipartFile.fromFile(image.path,
              filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
          'advertisingCountryAlphaCode': advertisingCountryAlphaCode,
          'advertisingBrand': advertisingBrand,
          'advertisingYear': advertisingYear,
          'advertisingLocation': advertisingLocation,
          'advertisingPrice': advertisingPrice,
          'advertisingType': advertisingType,
        });

        Response response = await dio.post(
            'https://net-zoon.onrender.com/advertisements/createAds',
            data: formData);
        // Handle the response as needed
        if (response.statusCode == 201) {
          return Right(response.data);
        } else {
          return Left(ServerFailure());
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
}
