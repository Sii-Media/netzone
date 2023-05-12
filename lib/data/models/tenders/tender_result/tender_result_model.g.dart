// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tender_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TenderResultModel _$TenderResultModelFromJson(Map<String, dynamic> json) =>
    TenderResultModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      tendersItems: (json['tendersItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TenderResultModelToJson(TenderResultModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'tendersItems': instance.tendersItems,
    };
