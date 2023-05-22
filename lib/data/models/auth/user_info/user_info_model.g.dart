// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      userType: json['userType'] as String,
      firstMobile: json['firstMobile'] as String,
      secondeMobile: json['secondeMobile'] as String?,
      thirdMobile: json['thirdMobile'] as String?,
      subcategory: json['subcategory'] as String?,
      address: json['address'] as String?,
      isFreeZoon: json['isFreeZoon'] as bool,
      businessLicense: json['businessLicense'] as String?,
      companyProductsNumber: json['companyProductsNumber'] as int?,
      sellType: json['sellType'] as String?,
      toCountry: json['toCountry'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      coverPhoto: json['coverPhoto'] as String?,
      banerPhoto: json['banerPhoto'] as String?,
      vehicles: json['vehicles'] as List<dynamic>?,
      products: json['products'] as List<dynamic>?,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'userType': instance.userType,
      'firstMobile': instance.firstMobile,
      'isFreeZoon': instance.isFreeZoon,
      'secondeMobile': instance.secondeMobile,
      'thirdMobile': instance.thirdMobile,
      'subcategory': instance.subcategory,
      'address': instance.address,
      'businessLicense': instance.businessLicense,
      'companyProductsNumber': instance.companyProductsNumber,
      'sellType': instance.sellType,
      'toCountry': instance.toCountry,
      'profilePhoto': instance.profilePhoto,
      'coverPhoto': instance.coverPhoto,
      'banerPhoto': instance.banerPhoto,
      'vehicles': instance.vehicles,
      'products': instance.products,
      '_id': instance.id,
    };
