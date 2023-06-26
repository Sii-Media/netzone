import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
part 'user_info_model.g.dart';

@JsonSerializable()
class UserInfoModel {
  final String? username;
  final String? email;
  final String? password;
  final String? userType;
  final String? firstMobile;
  final bool? isFreeZoon;
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

  final List? vehicles;
  final List? products;

  @JsonKey(name: '_id')
  final String id;

  UserInfoModel({
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
    this.bio,
    this.description,
    this.website,
    this.profilePhoto,
    this.coverPhoto,
    this.banerPhoto,
    this.vehicles,
    this.products,
    required this.id,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}

extension MapToDomain on UserInfoModel {
  UserInfo toDomain() => UserInfo(
      username: username,
      email: email,
      password: password,
      userType: userType,
      firstMobile: firstMobile,
      isFreeZoon: isFreeZoon,
      secondeMobile: secondeMobile,
      thirdMobile: thirdMobile,
      subcategory: subcategory,
      address: address,
      businessLicense: businessLicense,
      companyProductsNumber: companyProductsNumber,
      sellType: sellType,
      toCountry: toCountry,
      bio: bio,
      description: description,
      website: website,
      profilePhoto: profilePhoto,
      coverPhoto: coverPhoto,
      banerPhoto: banerPhoto,
      vehicles: vehicles,
      products: products,
      id: id);
}
