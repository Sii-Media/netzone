import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class AdvertismentRepository {
  Future<Either<Failure, Advertising>> getAllAds();

  Future<Either<Failure, Advertisement>> getAdsById({
    required String id,
  });

  Future<Either<Failure, Advertising>> getAdvertisementByType({
    required String userAdvertisingType,
  });
  Future<Either<Failure, String>> addAdvertisement({
    required String advertisingTitle,
    required String advertisingStartDate,
    required String advertisingEndDate,
    required String advertisingDescription,
    required File image,
    required String advertisingCountryAlphaCode,
    required String advertisingBrand,
    required String advertisingYear,
    required String advertisingLocation,
    required double advertisingPrice,
    required String advertisingType,
  });
}
