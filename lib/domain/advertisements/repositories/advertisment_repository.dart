import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:share_plus/share_plus.dart';

abstract class AdvertismentRepository {
  Future<Either<Failure, Advertising>> getAllAds({
    String? owner,
    int? priceMin,
    int? priceMax,
    bool? purchasable,
    String? year,
  });

  Future<Either<Failure, Advertising>> getUserAds({
    required String userId,
  });

  Future<Either<Failure, Advertisement>> getAdsById({
    required String id,
  });

  Future<Either<Failure, Advertising>> getAdvertisementByType({
    required String userAdvertisingType,
  });
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
  });

  Future<Either<Failure, String>> editAdvertisement({
    required String id,
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
    String? contactNumber,
  });

  Future<Either<Failure, String>> deleteAdvertisement({
    required String id,
  });
  Future<Either<Failure, String>> addAdsVisitor({
    required String adsId,
    required String viewerUserId,
  });
}
