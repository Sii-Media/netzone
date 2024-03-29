// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_company_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalCompanyCategoryModel _$LocalCompanyCategoryModelFromJson(
        Map<String, dynamic> json) =>
    LocalCompanyCategoryModel(
      id: json['_id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
    );

Map<String, dynamic> _$LocalCompanyCategoryModelToJson(
        LocalCompanyCategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
    };
