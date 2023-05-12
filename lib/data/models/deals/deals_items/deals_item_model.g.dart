// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealsItemsModel _$DealsItemsModelFromJson(Map<String, dynamic> json) =>
    DealsItemsModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      companyName: json['companyName'] as String,
      prevPrice: json['prevPrice'] as int,
      currentPrice: json['currentPrice'] as int,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$DealsItemsModelToJson(DealsItemsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'companyName': instance.companyName,
      'prevPrice': instance.prevPrice,
      'currentPrice': instance.currentPrice,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'location': instance.location,
      'category': instance.category,
    };
