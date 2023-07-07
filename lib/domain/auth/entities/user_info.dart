class UserInfo {
  final String? username;
  final String? email;
  final String? password;
  final String? userType;
  final String? firstMobile;
  final bool? isFreeZoon;
  final bool? deliverable;

  final String? secondeMobile;

  final String? thirdMobile;

  final String? subcategory;

  final String? address;

  final String? businessLicense;
  final int? companyProductsNumber;

  final String? sellType;

  final String? toCountry;
  final String? bio;
  final String? description;
  final String? website;
  final String? profilePhoto;
  final String? coverPhoto;
  final String? banerPhoto;
  final String? frontIdPhoto;
  final String? backIdPhoto;
  final List? vehicles;
  final List? products;

  final String id;

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
    this.deliverable,
    this.businessLicense,
    this.companyProductsNumber,
    this.sellType,
    this.toCountry,
    this.bio,
    this.description,
    this.website,
    this.profilePhoto,
    this.coverPhoto,
    this.banerPhoto,
    this.frontIdPhoto,
    this.backIdPhoto,
    this.vehicles,
    this.products,
    required this.id,
  });
}
