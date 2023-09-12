class UserInfo {
  final String? username;
  final String? email;
  final String? password;
  final String? userType;
  final String? firstMobile;
  final bool? isFreeZoon;
  final bool? isService;
  final bool? isSelectable;

  final String? freezoneCity;
  final bool? deliverable;

  final String? secondeMobile;

  final String? thirdMobile;

  final String? subcategory;

  final String? address;

  final String? businessLicense;
  final int? companyProductsNumber;

  final String? sellType;
  final String? country;
  final String? toCountry;
  final String? bio;
  final String? description;
  final String? website;
  final String? slogn;
  final String? link;
  final String? profilePhoto;
  final String? coverPhoto;
  final String? banerPhoto;
  final String? frontIdPhoto;
  final String? backIdPhoto;
  final String? tradeLicensePhoto;
  final String? deliveryPermitPhoto;
  final bool? isThereWarehouse;
  final bool? isThereFoodsDelivery;
  final String? deliveryType;
  final int? deliveryCarsNum;
  final int? deliveryMotorsNum;

  final List? vehicles;
  final List? products;
  final List<String>? followings;
  final List<String>? followers;

  final String id;
  final double? averageRating;
  final int? totalRatings;
  final int? profileViews;
  final double? profitRatio;

  final DateTime? subscriptionExpireDate;
  final int? realEstateListingsRemaining;
  final int? advertisementsRemaining;
  final int? carsListingsRemaining;
  final int? planesListingsRemaining;

  UserInfo({
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    this.secondeMobile,
    this.thirdMobile,
    this.subcategory,
    this.address,
    required this.isFreeZoon,
    this.isService,
    this.isSelectable,
    this.freezoneCity,
    this.deliverable,
    this.businessLicense,
    this.companyProductsNumber,
    this.sellType,
    this.country,
    this.toCountry,
    this.bio,
    this.description,
    this.website,
    this.slogn,
    this.link,
    this.profilePhoto,
    this.coverPhoto,
    this.banerPhoto,
    this.frontIdPhoto,
    this.backIdPhoto,
    this.vehicles,
    this.products,
    this.followings,
    this.followers,
    required this.id,
    this.tradeLicensePhoto,
    this.deliveryPermitPhoto,
    this.isThereWarehouse,
    this.isThereFoodsDelivery,
    this.deliveryType,
    this.deliveryCarsNum,
    this.deliveryMotorsNum,
    this.averageRating,
    this.totalRatings,
    this.profileViews,
    this.profitRatio,
    this.subscriptionExpireDate,
    this.realEstateListingsRemaining,
    this.advertisementsRemaining,
    this.carsListingsRemaining,
    this.planesListingsRemaining,
  });
}
