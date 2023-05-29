// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_companies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactoryCompaniesModel _$FactoryCompaniesModelFromJson(
        Map<String, dynamic> json) =>
    FactoryCompaniesModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imgurl: json['imgurl'] as String,
    );

Map<String, dynamic> _$FactoryCompaniesModelToJson(
        FactoryCompaniesModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imgurl': instance.imgurl,
    };
