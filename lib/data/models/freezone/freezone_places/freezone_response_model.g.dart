// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezone_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeZoneResponseModel _$FreeZoneResponseModelFromJson(
        Map<String, dynamic> json) =>
    FreeZoneResponseModel(
      json['message'] as String,
      (json['results'] as List<dynamic>)
          .map((e) => FreeZoneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FreeZoneResponseModelToJson(
        FreeZoneResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.freezones,
    };
