// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_amount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalAmountModel _$TotalAmountModelFromJson(Map<String, dynamic> json) =>
    TotalAmountModel(
      currencyCode: json['CurrencyCode'] as String,
      value: (json['Value'] as num).toDouble(),
    );

Map<String, dynamic> _$TotalAmountModelToJson(TotalAmountModel instance) =>
    <String, dynamic>{
      'CurrencyCode': instance.currencyCode,
      'Value': instance.value,
    };
