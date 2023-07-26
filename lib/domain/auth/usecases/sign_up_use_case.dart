import 'dart:io';

import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class SignUpUseCase extends UseCase<User, SignUpUseCaseParams> {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(SignUpUseCaseParams params) {
    return authRepository.signUp(
      username: params.username,
      email: params.email,
      password: params.password,
      userType: params.userType,
      firstMobile: params.firstMobile,
      isFreeZoon: params.isFreeZoon,
      isService: params.isService,
      freezoneCity: params.freezoneCity,
      country: params.country,
      secondMobile: params.secondMobile,
      thirdMobile: params.thirdMobile,
      address: params.address,
      companyProductsNumbe: params.companyProductsNumber,
      sellType: params.sellType,
      subcategory: params.subcategory,
      toCountry: params.toCountry,
      deliverable: params.deliverable,
      profilePhoto: params.profilePhoto,
      coverPhoto: params.coverPhoto,
      banerPhoto: params.banerPhoto,
      frontIdPhoto: params.frontIdPhoto,
      backIdPhoto: params.backIdPhoto,
      bio: params.bio,
      description: params.description,
      website: params.website,
      slogn: params.slogn,
      link: params.link,
      title: params.title,
      tradeLicensePhoto: params.tradeLicensePhoto,
      deliveryPermitPhoto: params.deliveryPermitPhoto,
      deliveryCarsNum: params.deliveryCarsNum,
      deliveryMotorsNum: params.deliveryMotorsNum,
      deliveryType: params.deliveryType,
      isThereFoodsDelivery: params.isThereFoodsDelivery,
      isThereWarehouse: params.isThereWarehouse,
    );
  }
}

class SignUpUseCaseParams {
  final String username;
  final String email;
  final String password;
  final String userType;
  final String firstMobile;
  final String country;
  final String? secondMobile;
  final String? thirdMobile;
  final String? subcategory;
  final String? address;
  final int? companyProductsNumber;
  final String? sellType;
  final String? toCountry;

  final bool isFreeZoon;
  final bool? isService;
  final String? freezoneCity;

  final bool? deliverable;
  final File? profilePhoto;
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
  SignUpUseCaseParams({
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    required this.isFreeZoon,
    this.isService,
    this.freezoneCity,
    required this.deliverable,
    required this.country,
    this.secondMobile,
    this.thirdMobile,
    this.subcategory,
    this.address,
    this.companyProductsNumber,
    this.sellType,
    this.toCountry,
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
  });
}
