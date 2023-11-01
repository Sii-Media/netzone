// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shiper_or_consignee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipperOrConsigneeModel _$ShipperOrConsigneeModelFromJson(
        Map<String, dynamic> json) =>
    ShipperOrConsigneeModel(
      reference1: json['Reference1'] as String?,
      accountNumber: json['AccountNumber'] as String,
      partyAddress: PartyAddressModel.fromJson(
          json['PartyAddress'] as Map<String, dynamic>),
      contact: ContactModel.fromJson(json['Contact'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShipperOrConsigneeModelToJson(
        ShipperOrConsigneeModel instance) =>
    <String, dynamic>{
      'Reference1': instance.reference1,
      'AccountNumber': instance.accountNumber,
      'PartyAddress': instance.partyAddress,
      'Contact': instance.contact,
    };
