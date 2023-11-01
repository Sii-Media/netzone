// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentItemsModel _$ShipmentItemsModelFromJson(Map<String, dynamic> json) =>
    ShipmentItemsModel(
      packageType: json['PackageType'] as String,
      quantity: json['Quantity'] as int,
      weight:
          ActualWeightModel.fromJson(json['Weight'] as Map<String, dynamic>),
      comments: json['Comments'] as String,
      reference: json['Reference'] as String,
      commodityCode: json['CommodityCode'] as int,
      goodsDescription: json['GoodsDescription'] as String,
      countryOfOrigin: json['CountryOfOrigin'] as String,
      customsValue: TotalAmountModel.fromJson(
          json['CustomsValue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShipmentItemsModelToJson(ShipmentItemsModel instance) =>
    <String, dynamic>{
      'PackageType': instance.packageType,
      'Quantity': instance.quantity,
      'Weight': instance.weight,
      'Comments': instance.comments,
      'Reference': instance.reference,
      'CommodityCode': instance.commodityCode,
      'GoodsDescription': instance.goodsDescription,
      'CountryOfOrigin': instance.countryOfOrigin,
      'CustomsValue': instance.customsValue,
    };
