// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeZoneModel _$FreeZoneModelFromJson(Map<String, dynamic> json) =>
    FreeZoneModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$FreeZoneModelToJson(FreeZoneModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };
