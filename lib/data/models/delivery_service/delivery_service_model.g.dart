// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryServiceModel _$DeliveryServiceModelFromJson(
        Map<String, dynamic> json) =>
    DeliveryServiceModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      price: json['price'] as int,
      owner: UserInfoModel.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeliveryServiceModelToJson(
        DeliveryServiceModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'from': instance.from,
      'to': instance.to,
      'price': instance.price,
      'owner': instance.owner,
    };
