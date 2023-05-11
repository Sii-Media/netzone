class UserInfo {
  final String username;
  final String email;
  final String password;
  final String userType;
  final String firstMobile;
  final bool isFreeZoon;
  final String? secondeMobile;

  final String? thirdMobile;

  final String? subcategory;

  final String? address;

  final String? businessLicense;
  final String? companyProductsNumber;

  final String? sellType;

  final String? toCountry;

  final String? profilePhoto;
  final String? banerPhoto;

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
    this.businessLicense,
    this.companyProductsNumber,
    this.sellType,
    this.toCountry,
    this.profilePhoto,
    this.banerPhoto,
    this.vehicles,
    this.products,
    required this.id,
  });
}
