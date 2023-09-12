// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_advice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalAdviceModel _$LegalAdviceModelFromJson(Map<String, dynamic> json) =>
    LegalAdviceModel(
      id: json['_id'] as String?,
      text: json['text'] as String,
      textEn: json['textEn'] as String,
    );

Map<String, dynamic> _$LegalAdviceModelToJson(LegalAdviceModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'textEn': instance.textEn,
    };
