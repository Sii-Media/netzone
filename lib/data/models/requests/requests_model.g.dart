// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestsModel _$RequestsModelFromJson(Map<String, dynamic> json) =>
    RequestsModel(
      id: json['_id'] as String?,
      address: json['address'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$RequestsModelToJson(RequestsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'address': instance.address,
      'text': instance.text,
    };
