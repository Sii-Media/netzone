part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final String username;
  final String email;
  final String password;
  final String userType;
  final String firstMobile;
  final String? secondMobile;
  final String? thirdMobile;
  final String? subcategory;
  final String? address;
  final int? companyProductsNumber;
  final String? sellType;
  final String? toCountry;

  final bool isFreeZoon;
  final bool? isService;
  final bool? isSelectable;

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
  final double? profitRatio;
  final String? city;
  final String? addressDetails;
  final int? floorNum;
  final String? locationType;
  final String? contactName;
  final bool? withAdd;
  const SignUpRequested({
    required this.username,
    required this.contactName,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    this.secondMobile,
    this.thirdMobile,
    this.subcategory,
    required this.address,
    this.companyProductsNumber,
    this.sellType,
    this.toCountry,
    required this.isFreeZoon,
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
    required this.city,
    this.addressDetails,
    this.floorNum,
    this.locationType,
    this.withAdd,
  });
}
