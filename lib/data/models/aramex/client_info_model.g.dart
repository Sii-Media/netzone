// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientInfoModel _$ClientInfoModelFromJson(Map<String, dynamic> json) =>
    ClientInfoModel(
      source: json['Source'] as int,
      accountCountryCode: json['AccountCountryCode'] as String,
      accountEntity: json['AccountEntity'] as String,
      accountPin: json['AccountPin'] as String,
      accountNumber: json['AccountNumber'] as String,
      userName: json['UserName'] as String,
      password: json['Password'] as String,
      version: json['Version'] as String,
    );

Map<String, dynamic> _$ClientInfoModelToJson(ClientInfoModel instance) =>
    <String, dynamic>{
      'Source': instance.source,
      'AccountCountryCode': instance.accountCountryCode,
      'AccountEntity': instance.accountEntity,
      'AccountPin': instance.accountPin,
      'AccountNumber': instance.accountNumber,
      'UserName': instance.userName,
      'Password': instance.password,
      'Version': instance.version,
    };
