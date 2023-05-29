// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezone_results_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreezoneResultModel _$FreezoneResultModelFromJson(Map<String, dynamic> json) =>
    FreezoneResultModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      freezoonplaces: (json['freezoonplaces'] as List<dynamic>)
          .map((e) => FreeZoneCompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FreezoneResultModelToJson(
        FreezoneResultModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'freezoonplaces': instance.freezoonplaces,
    };
