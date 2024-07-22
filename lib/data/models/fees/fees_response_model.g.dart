// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fees_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeesResponseModel _$FeesResponseModelFromJson(Map<String, dynamic> json) =>
    FeesResponseModel(
      feesFromSeller: (json['feesFromSeller'] as num?)?.toDouble(),
      feesFromBuyer: (json['feesFromBuyer'] as num?)?.toDouble(),
      adsFees: (json['adsFees'] as num?)?.toDouble(),
      dealsFees: (json['dealsFees'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FeesResponseModelToJson(FeesResponseModel instance) =>
    <String, dynamic>{
      'feesFromSeller': instance.feesFromSeller,
      'feesFromBuyer': instance.feesFromBuyer,
      'adsFees': instance.adsFees,
      'dealsFees': instance.dealsFees,
    };
