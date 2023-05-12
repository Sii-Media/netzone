// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tender_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TenderResponseModel _$TenderResponseModelFromJson(Map<String, dynamic> json) =>
    TenderResponseModel(
      message: json['message'] as String,
      tendersResult: (json['results'] as List<dynamic>)
          .map((e) => TenderResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TenderResponseModelToJson(
        TenderResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.tendersResult,
    };
