// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealsResultModel _$DealsResultModelFromJson(Map<String, dynamic> json) =>
    DealsResultModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      dealsItems: (json['dealsItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DealsResultModelToJson(DealsResultModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'dealsItems': instance.dealsItems,
    };
