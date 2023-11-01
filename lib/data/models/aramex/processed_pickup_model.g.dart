// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processed_pickup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessedPickupModel _$ProcessedPickupModelFromJson(
        Map<String, dynamic> json) =>
    ProcessedPickupModel(
      id: json['ID'] as String,
      guid: json['GUID'] as String,
      reference1: json['Reference1'] as String,
    );

Map<String, dynamic> _$ProcessedPickupModelToJson(
        ProcessedPickupModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'GUID': instance.guid,
      'Reference1': instance.reference1,
    };
