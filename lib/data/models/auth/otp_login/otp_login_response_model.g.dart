// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpLoginResponseModel _$OtpLoginResponseModelFromJson(
        Map<String, dynamic> json) =>
    OtpLoginResponseModel(
      message: json['message'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$OtpLoginResponseModelToJson(
        OtpLoginResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
