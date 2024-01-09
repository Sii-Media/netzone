// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      message: json['message'] as String,
      userInfo: UserInfoModel.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'message': instance.message,
      'result': instance.userInfo,
    };
