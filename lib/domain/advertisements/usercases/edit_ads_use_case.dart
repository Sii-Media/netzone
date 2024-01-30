import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:share_plus/share_plus.dart';

import '../repositories/advertisment_repository.dart';

class EditAdsUseCase extends UseCase<String, EditAdsParams> {
  final AdvertismentRepository advertismentRepository;

  EditAdsUseCase({required this.advertismentRepository});

  @override
  Future<Either<Failure, String>> call(EditAdsParams params) {
    return advertismentRepository.editAdvertisement(
        id: params.id,
        advertisingTitle: params.advertisingTitle,
        advertisingStartDate: params.advertisingStartDate,
        advertisingEndDate: params.advertisingEndDate,
        advertisingDescription: params.advertisingDescription,
        image: params.image,
        advertisingYear: params.advertisingYear,
        advertisingLocation: params.advertisingLocation,
        advertisingPrice: params.advertisingPrice,
        advertisingType: params.advertisingType,
        purchasable: params.purchasable,
        color: params.color,
        category: params.category,
        contactNumber: params.contactNumber,
        type: params.type,
        guarantee: params.guarantee,
        advertisingImageList: params.advertisingImageList,
        video: params.video);
  }
}

class EditAdsParams {
  final String id;
  final String advertisingTitle;
  final String advertisingStartDate;
  final String advertisingEndDate;
  final String advertisingDescription;
  final File? image;
  final String advertisingYear;
  final String advertisingLocation;
  final double advertisingPrice;
  final String advertisingType;
  final List<XFile>? advertisingImageList;
  final File? video;
  final bool purchasable;
  final String? type;
  final String? category;
  final String? color;
  final bool? guarantee;
  final String? contactNumber;

  EditAdsParams(
      {required this.id,
      required this.advertisingTitle,
      required this.advertisingStartDate,
      required this.advertisingEndDate,
      required this.advertisingDescription,
      this.image,
      required this.advertisingYear,
      required this.advertisingLocation,
      required this.advertisingPrice,
      required this.advertisingType,
      this.advertisingImageList,
      this.video,
      required this.purchasable,
      this.type,
      this.category,
      this.color,
      this.guarantee,
      this.contactNumber});
}
