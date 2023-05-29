// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'govermental_companies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GovermentalCompaniesModel _$GovermentalCompaniesModelFromJson(
        Map<String, dynamic> json) =>
    GovermentalCompaniesModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      govermentalCompanies: (json['govermentalCompanies'] as List<dynamic>)
          .map((e) =>
              GovermentalDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GovermentalCompaniesModelToJson(
        GovermentalCompaniesModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'govermentalCompanies': instance.govermentalCompanies,
    };
