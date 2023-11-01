// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_rate_input_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculateRateInputDataModel _$CalculateRateInputDataModelFromJson(
        Map<String, dynamic> json) =>
    CalculateRateInputDataModel(
      originAddress: PartyAddressModel.fromJson(
          json['OriginAddress'] as Map<String, dynamic>),
      destinationAddress: PartyAddressModel.fromJson(
          json['DestinationAddress'] as Map<String, dynamic>),
      shipmentDetails: RateShipmentDetailsModel.fromJson(
          json['ShipmentDetails'] as Map<String, dynamic>),
      preferredCurrencyCode: json['PreferredCurrencyCode'] as String,
      clientInfo:
          ClientInfoModel.fromJson(json['ClientInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CalculateRateInputDataModelToJson(
        CalculateRateInputDataModel instance) =>
    <String, dynamic>{
      'OriginAddress': instance.originAddress,
      'DestinationAddress': instance.destinationAddress,
      'ShipmentDetails': instance.shipmentDetails,
      'PreferredCurrencyCode': instance.preferredCurrencyCode,
      'ClientInfo': instance.clientInfo,
    };
