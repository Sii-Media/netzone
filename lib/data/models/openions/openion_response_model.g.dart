// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openion_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenionResponseModel _$OpenionResponseModelFromJson(
        Map<String, dynamic> json) =>
    OpenionResponseModel(
      message: json['message'] as String,
      openionModel:
          OpenionModel.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpenionResponseModelToJson(
        OpenionResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.openionModel,
    };
