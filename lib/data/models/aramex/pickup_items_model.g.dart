// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickUpItemsModel _$PickUpItemsModelFromJson(Map<String, dynamic> json) =>
    PickUpItemsModel(
      productGroup: json['ProductGroup'] as String,
      productType: json['ProductType'] as String,
      numberOfShipments: json['NumberOfShipments'] as int,
      packageTypel: json['PackageTypel'] as String,
      payment: json['Payment'] as String,
      shipmentWeight: ActualWeightModel.fromJson(
          json['ShipmentWeight'] as Map<String, dynamic>),
      numberOfPieces: json['NumberOfPieces'] as int,
      shipmentDimensions: ShipmentDimensionsModel.fromJson(
          json['ShipmentDimensions'] as Map<String, dynamic>),
      comments: json['Comments'] as String,
    );

Map<String, dynamic> _$PickUpItemsModelToJson(PickUpItemsModel instance) =>
    <String, dynamic>{
      'ProductGroup': instance.productGroup,
      'ProductType': instance.productType,
      'NumberOfShipments': instance.numberOfShipments,
      'PackageTypel': instance.packageTypel,
      'Payment': instance.payment,
      'ShipmentWeight': instance.shipmentWeight,
      'NumberOfPieces': instance.numberOfPieces,
      'ShipmentDimensions': instance.shipmentDimensions,
      'Comments': instance.comments,
    };
