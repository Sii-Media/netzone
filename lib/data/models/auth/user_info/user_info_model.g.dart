// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      username: json['username'] as String,
      email: json['email'] as String?,
      password: json['password'] as String?,
      userType: json['userType'] as String?,
      firstMobile: json['firstMobile'] as String?,
      secondeMobile: json['secondeMobile'] as String?,
      thirdMobile: json['thirdMobile'] as String?,
      subcategory: json['subcategory'] as String?,
      address: json['address'] as String?,
      isFreeZoon: json['isFreeZoon'] as bool?,
      deliverable: json['deliverable'] as bool?,
      businessLicense: json['businessLicense'] as String?,
      companyProductsNumber: json['companyProductsNumber'] as int?,
      sellType: json['sellType'] as String?,
      toCountry: json['toCountry'] as String?,
      bio: json['bio'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      coverPhoto: json['coverPhoto'] as String?,
      banerPhoto: json['banerPhoto'] as String?,
      vehicles: json['vehicles'] as List<dynamic>?,
      products: json['products'] as List<dynamic>?,
      followings: (json['followings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
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
      'deliverable': instance.deliverable,
      'secondeMobile': instance.secondeMobile,
      'thirdMobile': instance.thirdMobile,
      'subcategory': instance.subcategory,
      'address': instance.address,
      'businessLicense': instance.businessLicense,
      'companyProductsNumber': instance.companyProductsNumber,
      'sellType': instance.sellType,
      'toCountry': instance.toCountry,
      'bio': instance.bio,
      'description': instance.description,
      'website': instance.website,
      'profilePhoto': instance.profilePhoto,
      'coverPhoto': instance.coverPhoto,
      'banerPhoto': instance.banerPhoto,
      'vehicles': instance.vehicles,
      'products': instance.products,
      'followings': instance.followings,
      'followers': instance.followers,
      '_id': instance.id,
    };
