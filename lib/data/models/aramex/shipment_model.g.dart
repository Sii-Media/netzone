// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentsModel _$ShipmentsModelFromJson(Map<String, dynamic> json) =>
    ShipmentsModel(
      reference1: json['Reference1'] as String?,
      reference2: json['Reference2'] as String?,
      reference3: json['Reference3'] as String?,
      shipper: ShipperOrConsigneeModel.fromJson(
          json['Shipper'] as Map<String, dynamic>),
      consignee: ShipperOrConsigneeModel.fromJson(
          json['Consignee'] as Map<String, dynamic>),
      thirdParty: json['ThirdParty'] as String?,
      shippingDateTime: json['ShippingDateTime'] as String,
      dueDate: json['DueDate'] as String?,
      comments: json['Comments'] as String?,
      details: ShipmentDetailsModel.fromJson(
          json['Details'] as Map<String, dynamic>),
      transportType: json['TransportType'] as int,
      pickupGUID: json['PickupGUID'] as String?,
    );

Map<String, dynamic> _$ShipmentsModelToJson(ShipmentsModel instance) =>
    <String, dynamic>{
      'Reference1': instance.reference1,
      'Reference2': instance.reference2,
      'Reference3': instance.reference3,
      'Shipper': instance.shipper,
      'Consignee': instance.consignee,
      'ThirdParty': instance.thirdParty,
      'ShippingDateTime': instance.shippingDateTime,
      'DueDate': instance.dueDate,
      'Comments': instance.comments,
      'Details': instance.details,
      'TransportType': instance.transportType,
      'PickupGUID': instance.pickupGUID,
    };
