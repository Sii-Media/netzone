import 'dart:io';

import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:share_plus/share_plus.dart';

class AddAdvertisementUseCase extends UseCase<String, AddAdvertisementParams> {
  final AdvertismentRepository advertismentRepository;

  AddAdvertisementUseCase({required this.advertismentRepository});
  @override
  Future<Either<Failure, String>> call(AddAdvertisementParams params) {
    return advertismentRepository.addAdvertisement(
      owner: params.owner,
      advertisingTitle: params.advertisingTitle,
      advertisingStartDate: params.advertisingStartDate,
      advertisingEndDate: params.advertisingEndDate,
      advertisingDescription: params.advertisingDescription,
      image: params.image,
      advertisingCountryAlphaCode: params.advertisingCountryAlphaCode,
      advertisingBrand: params.advertisingBrand,
      advertisingYear: params.advertisingYear,
      advertisingLocation: params.advertisingLocation,
      advertisingPrice: params.advertisingPrice,
      advertisingType: params.advertisingType,
      advertisingImageList: params.advertisingImageList,
      video: params.video,
      purchasable: params.purchasable,
    );
  }
}

class AddAdvertisementParams {
  final String owner;
  final String advertisingTitle;
  final String advertisingStartDate;
  final String advertisingEndDate;
  final String advertisingDescription;
  final File image;
  final String advertisingCountryAlphaCode;
  final String advertisingBrand;
  final String advertisingYear;
  final String advertisingLocation;
  final double advertisingPrice;
  final String advertisingType;
  final List<XFile>? advertisingImageList;
  final File? video;
  final bool purchasable;

  AddAdvertisementParams({
    required this.owner,
    required this.advertisingTitle,
    required this.advertisingStartDate,
    required this.advertisingEndDate,
    required this.advertisingDescription,
    required this.image,
    required this.advertisingCountryAlphaCode,
    required this.advertisingBrand,
    required this.advertisingYear,
    required this.advertisingLocation,
    required this.advertisingPrice,
    required this.advertisingType,
    this.advertisingImageList,
    this.video,
    required this.purchasable,
  });
}
