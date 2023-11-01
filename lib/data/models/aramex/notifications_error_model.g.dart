// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsErrorModel _$NotificationsErrorModelFromJson(
        Map<String, dynamic> json) =>
    NotificationsErrorModel(
      code: json['Code'] as String,
      message: json['Message'] as String,
    );

Map<String, dynamic> _$NotificationsErrorModelToJson(
        NotificationsErrorModel instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Message': instance.message,
    };
