// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenders_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TendersItemModel _$TendersItemModelFromJson(Map<String, dynamic> json) =>
    TendersItemModel(
      id: json['_id'] as String?,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      companyName: json['companyName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      price: json['price'] as int,
      type: json['type'] as String,
      value: json['value'] as int,
      category: json['category'] as String,
    );

Map<String, dynamic> _$TendersItemModelToJson(TendersItemModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'companyName': instance.companyName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'price': instance.price,
      'type': instance.type,
      'value': instance.value,
      'category': instance.category,
    };
