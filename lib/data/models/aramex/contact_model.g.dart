// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      department: json['Department'] as String?,
      personName: json['PersonName'] as String,
      title: json['Title'] as String?,
      companyName: json['CompanyName'] as String,
      phoneNumber1: json['PhoneNumber1'] as String,
      cellPhone: json['CellPhone'] as String,
      emailAddress: json['EmailAddress'] as String,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'Department': instance.department,
      'PersonName': instance.personName,
      'Title': instance.title,
      'CompanyName': instance.companyName,
      'PhoneNumber1': instance.phoneNumber1,
      'CellPhone': instance.cellPhone,
      'EmailAddress': instance.emailAddress,
    };
