// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceCategoryModel _$ServiceCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ServiceCategoryModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => CompanyServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServiceCategoryModelToJson(
        ServiceCategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'services': instance.services,
    };
