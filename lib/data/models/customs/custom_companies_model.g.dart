// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_companies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomsCompaniesModel _$CustomsCompaniesModelFromJson(
        Map<String, dynamic> json) =>
    CustomsCompaniesModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      customsplaces: (json['customsplaces'] as List<dynamic>)
          .map((e) => CustomsCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomsCompaniesModelToJson(
        CustomsCompaniesModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'customsplaces': instance.customsplaces,
    };
