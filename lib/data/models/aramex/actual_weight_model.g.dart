// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actual_weight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActualWeightModel _$ActualWeightModelFromJson(Map<String, dynamic> json) =>
    ActualWeightModel(
      unit: json['Unit'] as String,
      value: (json['Value'] as num).toDouble(),
    );

Map<String, dynamic> _$ActualWeightModelToJson(ActualWeightModel instance) =>
    <String, dynamic>{
      'Unit': instance.unit,
      'Value': instance.value,
    };
