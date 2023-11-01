// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentDetailsModel _$ShipmentDetailsModelFromJson(
        Map<String, dynamic> json) =>
    ShipmentDetailsModel(
      actualWeight: ActualWeightModel.fromJson(
          json['ActualWeight'] as Map<String, dynamic>),
      descriptionOfGoods: json['DescriptionOfGoods'] as String,
      goodsOriginCountry: json['GoodsOriginCountry'] as String,
      numberOfPieces: json['NumberOfPieces'] as int,
      productGroup: json['ProductGroup'] as String,
      productType: json['ProductType'] as String,
      paymentType: json['PaymentType'] as String,
      items: (json['Items'] as List<dynamic>?)
          ?.map((e) => ShipmentItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShipmentDetailsModelToJson(
        ShipmentDetailsModel instance) =>
    <String, dynamic>{
      'ActualWeight': instance.actualWeight,
      'DescriptionOfGoods': instance.descriptionOfGoods,
      'GoodsOriginCountry': instance.goodsOriginCountry,
      'NumberOfPieces': instance.numberOfPieces,
      'ProductGroup': instance.productGroup,
      'ProductType': instance.productType,
      'PaymentType': instance.paymentType,
      'Items': instance.items,
    };
