// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaints_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintsModel _$ComplaintsModelFromJson(Map<String, dynamic> json) =>
    ComplaintsModel(
      id: json['_id'] as String?,
      address: json['address'] as String,
      text: json['text'] as String,
      reply: json['reply'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ComplaintsModelToJson(ComplaintsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'address': instance.address,
      'text': instance.text,
      'reply': instance.reply,
      'createdAt': instance.createdAt,
    };
