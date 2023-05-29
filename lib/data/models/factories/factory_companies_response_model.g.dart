// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_companies_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactoryCompaniesResponseModel _$FactoryCompaniesResponseModelFromJson(
        Map<String, dynamic> json) =>
    FactoryCompaniesResponseModel(
      factoryCompanies: (json['factory'] as List<dynamic>)
          .map((e) => FactoryCompaniesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FactoryCompaniesResponseModelToJson(
        FactoryCompaniesResponseModel instance) =>
    <String, dynamic>{
      'factory': instance.factoryCompanies,
    };
