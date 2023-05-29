// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'govermental_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GovermentalDetailsModel _$GovermentalDetailsModelFromJson(
        Map<String, dynamic> json) =>
    GovermentalDetailsModel(
      id: json['_id'] as String,
      govname: json['govname'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      phone: json['phone'] as String?,
      mobile: json['mobile'] as String?,
      info: json['info'] as String,
      videourl: json['videourl'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$GovermentalDetailsModelToJson(
        GovermentalDetailsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'govname': instance.govname,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'city': instance.city,
      'address': instance.address,
      'email': instance.email,
      'images': instance.images,
      'phone': instance.phone,
      'mobile': instance.mobile,
      'info': instance.info,
      'videourl': instance.videourl,
      'link': instance.link,
    };
