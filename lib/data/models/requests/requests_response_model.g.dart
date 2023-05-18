// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestsResponseModel _$RequestsResponseModelFromJson(
        Map<String, dynamic> json) =>
    RequestsResponseModel(
      message: json['message'] as String,
      requestsModel:
          RequestsModel.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestsResponseModelToJson(
        RequestsResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.requestsModel,
    };
