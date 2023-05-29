// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customs_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomsCategoryModel _$CustomsCategoryModelFromJson(
        Map<String, dynamic> json) =>
    CustomsCategoryModel(
      id: json['_id'] as String?,
      categoryName: json['categoryName'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      imgurl: json['imgurl'] as String,
      info: json['info'] as String,
      companyimages: (json['companyimages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      link: json['link'] as String?,
      videourl: json['videourl'] as String?,
    );

Map<String, dynamic> _$CustomsCategoryModelToJson(
        CustomsCategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'categoryName': instance.categoryName,
      'name': instance.name,
      'city': instance.city,
      'address': instance.address,
      'email': instance.email,
      'imgurl': instance.imgurl,
      'info': instance.info,
      'companyimages': instance.companyimages,
      'link': instance.link,
      'videourl': instance.videourl,
    };
