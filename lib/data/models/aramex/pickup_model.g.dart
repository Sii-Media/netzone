// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickUpModel _$PickUpModelFromJson(Map<String, dynamic> json) => PickUpModel(
      pickupAddress: PartyAddressModel.fromJson(
          json['PickupAddress'] as Map<String, dynamic>),
      pickupContact:
          ContactModel.fromJson(json['PickupContact'] as Map<String, dynamic>),
      pickupLocation: json['PickupLocation'] as String,
      pickupDate: json['PickupDate'] as String,
      readyTime: json['ReadyTime'] as String,
      lastPickupTime: json['LastPickupTime'] as String,
      closingTime: json['ClosingTime'] as String,
      comments: json['Comments'] as String,
      reference1: json['Reference1'] as String,
      vehicle: json['Vehicle'] as String,
      pickupItems: (json['PickupItems'] as List<dynamic>)
          .map((e) => PickUpItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['Status'] as String,
      branch: json['Branch'] as String,
      routeCode: json['RouteCode'] as String,
    );

Map<String, dynamic> _$PickUpModelToJson(PickUpModel instance) =>
    <String, dynamic>{
      'PickupAddress': instance.pickupAddress,
      'PickupContact': instance.pickupContact,
      'PickupLocation': instance.pickupLocation,
      'PickupDate': instance.pickupDate,
      'ReadyTime': instance.readyTime,
      'LastPickupTime': instance.lastPickupTime,
      'ClosingTime': instance.closingTime,
      'Comments': instance.comments,
      'Reference1': instance.reference1,
      'Vehicle': instance.vehicle,
      'PickupItems': instance.pickupItems,
      'Status': instance.status,
      'Branch': instance.branch,
      'RouteCode': instance.routeCode,
    };
