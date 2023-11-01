// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_shipment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateShipmentDetailsModel _$RateShipmentDetailsModelFromJson(
        Map<String, dynamic> json) =>
    RateShipmentDetailsModel(
      actualWeight: ActualWeightModel.fromJson(
          json['ActualWeight'] as Map<String, dynamic>),
      chargeableWeight: ActualWeightModel.fromJson(
          json['ChargeableWeight'] as Map<String, dynamic>),
      numberOfPieces: json['NumberOfPieces'] as int,
      productGroup: json['ProductGroup'] as String,
      productType: json['ProductType'] as String,
      paymentType: json['PaymentType'] as String,
      services: json['Services'] as String,
    );

Map<String, dynamic> _$RateShipmentDetailsModelToJson(
        RateShipmentDetailsModel instance) =>
    <String, dynamic>{
      'ActualWeight': instance.actualWeight,
      'ChargeableWeight': instance.chargeableWeight,
      'NumberOfPieces': instance.numberOfPieces,
      'ProductGroup': instance.productGroup,
      'ProductType': instance.productType,
      'PaymentType': instance.paymentType,
      'Services': instance.services,
    };
