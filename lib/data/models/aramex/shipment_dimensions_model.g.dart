// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_dimensions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentDimensionsModel _$ShipmentDimensionsModelFromJson(
        Map<String, dynamic> json) =>
    ShipmentDimensionsModel(
      length: json['Length'] as int,
      width: json['Width'] as int,
      height: json['Height'] as int,
      unit: json['Unit'] as String,
    );

Map<String, dynamic> _$ShipmentDimensionsModelToJson(
        ShipmentDimensionsModel instance) =>
    <String, dynamic>{
      'Length': instance.length,
      'Width': instance.width,
      'Height': instance.height,
      'Unit': instance.unit,
    };
