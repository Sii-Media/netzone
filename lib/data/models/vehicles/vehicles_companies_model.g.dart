// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicles_companies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclesCompaniesModel _$VehiclesCompaniesModelFromJson(
        Map<String, dynamic> json) =>
    VehiclesCompaniesModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      imgUrl: json['imgUrl'] as String,
      description: json['description'] as String,
      bio: json['bio'] as String,
      mobile: json['mobile'] as String,
      mail: json['mail'] as String,
      website: json['website'] as String,
      coverUrl: json['coverUrl'] as String?,
    );

Map<String, dynamic> _$VehiclesCompaniesModelToJson(
        VehiclesCompaniesModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'imgUrl': instance.imgUrl,
      'description': instance.description,
      'bio': instance.bio,
      'mobile': instance.mobile,
      'mail': instance.mail,
      'website': instance.website,
      'coverUrl': instance.coverUrl,
    };
