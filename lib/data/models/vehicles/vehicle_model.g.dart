// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      kilometers: json['kilometers'] as int,
      year: json['year'] as String,
      location: json['location'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      creator: json['creator'] as String?,
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'price': instance.price,
      'kilometers': instance.kilometers,
      'year': instance.year,
      'location': instance.location,
      'type': instance.type,
      'category': instance.category,
      'creator': instance.creator,
    };
