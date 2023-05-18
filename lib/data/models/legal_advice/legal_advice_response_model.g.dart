// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_advice_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalAdviceResponseModel _$LegalAdviceResponseModelFromJson(
        Map<String, dynamic> json) =>
    LegalAdviceResponseModel(
      message: json['message'] as String,
      legalAdiceModel: (json['results'] as List<dynamic>)
          .map((e) => LegalAdviceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LegalAdviceResponseModelToJson(
        LegalAdviceResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.legalAdiceModel,
    };
