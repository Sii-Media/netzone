// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartyAddressModel _$PartyAddressModelFromJson(Map<String, dynamic> json) =>
    PartyAddressModel(
      line1: json['Line1'] as String,
      line2: json['Line2'] as String?,
      line3: json['Line3'] as String?,
      city: json['City'] as String,
      stateOrProvinceCode: json['StateOrProvinceCode'] as String?,
      postCode: json['PostCode'] as String?,
      countryCode: json['CountryCode'] as String,
      longitude: json['Longitude'] as int,
      latitude: json['Latitude'] as int,
    );

Map<String, dynamic> _$PartyAddressModelToJson(PartyAddressModel instance) =>
    <String, dynamic>{
      'Line1': instance.line1,
      'Line2': instance.line2,
      'Line3': instance.line3,
      'City': instance.city,
      'StateOrProvinceCode': instance.stateOrProvinceCode,
      'PostCode': instance.postCode,
      'CountryCode': instance.countryCode,
      'Longitude': instance.longitude,
      'Latitude': instance.latitude,
    };
