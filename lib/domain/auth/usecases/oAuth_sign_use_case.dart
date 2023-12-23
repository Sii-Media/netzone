import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class OAuthSignUseCase extends UseCase<User, OAuthSignParams> {
  final AuthRepository authRepository;

  OAuthSignUseCase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(OAuthSignParams params) {
    return authRepository.oAuthSign(
      email: params.email,
      username: params.username,
      address: params.address,
      addressDetails: params.addressDetails,
      backIdPhoto: params.backIdPhoto,
      bio: params.bio,
      city: params.city,
      companyProductsNumber: params.companyProductsNumber,
      contactName: params.contactName,
      country: params.country,
      coverPhoto: params.coverPhoto,
      deliverable: params.deliverable,
      deliveryCarsNum: params.deliveryCarsNum,
      deliveryMotorsNum: params.deliveryMotorsNum,
      deliveryPermitPhoto: params.deliveryPermitPhoto,
      deliveryType: params.deliveryType,
      description: params.description,
      firstMobile: params.firstMobile,
      floorNum: params.floorNum,
      freezoneCity: params.freezoneCity,
      frontIdPhoto: params.frontIdPhoto,
      isFreeZoon: params.isFreeZoon,
      isSelectable: params.isSelectable,
      isService: params.isService,
      isThereFoodsDelivery: params.isThereFoodsDelivery,
      isThereWarehouse: params.isThereWarehouse,
      link: params.link,
      locationType: params.locationType,
      profilePhoto: params.profilePhoto,
      profitRatio: params.profitRatio,
      secondMobile: params.secondMobile,
      sellType: params.sellType,
      slogn: params.slogn,
      subcategory: params.subcategory,
      thirdMobile: params.thirdMobile,
      title: params.title,
      toCountry: params.toCountry,
      tradeLicensePhoto: params.tradeLicensePhoto,
      userType: params.userType,
      website: params.website,
    );
  }
}

class OAuthSignParams {
  final String? username;
  final String email;
  final String? userType;
  final String? firstMobile;
  final String? country;
  final String? secondMobile;
  final String? thirdMobile;
  final String? subcategory;
  final String? address;
  final int? companyProductsNumber;
  final String? sellType;
  final String? toCountry;

  final bool? isFreeZoon;
  final bool? isService;
  final bool? isSelectable;
  final String? freezoneCity;

  final bool? deliverable;
  final String? profilePhoto;
  final File? coverPhoto;
  final File? banerPhoto;
  final File? frontIdPhoto;
  final File? backIdPhoto;
  final String? bio;
  final String? description;
  final String? website;
  final String? slogn;
  final String? link;
  final String? title;
  final File? tradeLicensePhoto;
  final File? deliveryPermitPhoto;
  final bool? isThereWarehouse;
  final bool? isThereFoodsDelivery;
  final String? deliveryType;
  final int? deliveryCarsNum;
  final int? deliveryMotorsNum;
  final double? profitRatio;
  final String? city;
  final String? addressDetails;
  final int? floorNum;
  final String? locationType;
  final String? contactName;

  OAuthSignParams(
      {required this.username,
      required this.email,
      this.userType,
      this.firstMobile,
      required this.country,
      this.secondMobile,
      this.thirdMobile,
      this.subcategory,
      this.address,
      this.companyProductsNumber,
      this.sellType,
      this.toCountry,
      this.isFreeZoon,
      this.isService,
      this.isSelectable,
      this.freezoneCity,
      this.deliverable,
      this.profilePhoto,
      this.coverPhoto,
      this.banerPhoto,
      this.frontIdPhoto,
      this.backIdPhoto,
      this.bio,
      this.description,
      this.website,
      this.slogn,
      this.link,
      this.title,
      this.tradeLicensePhoto,
      this.deliveryPermitPhoto,
      this.isThereWarehouse,
      this.isThereFoodsDelivery,
      this.deliveryType,
      this.deliveryCarsNum,
      this.deliveryMotorsNum,
      this.profitRatio,
      this.city,
      this.addressDetails,
      this.floorNum,
      this.locationType,
      this.contactName});
}
