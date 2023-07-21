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
      creator: json['creator'] == null
          ? null
          : UserInfoModel.fromJson(json['creator'] as Map<String, dynamic>),
      carImages: (json['carImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vedioUrl: json['vedioUrl'] as String?,
      country: json['country'] as String,
      contactNumber: json['contactNumber'] as String?,
      exteriorColor: json['exteriorColor'] as String?,
      interiorColor: json['interiorColor'] as String?,
      doors: json['doors'] as int?,
      bodyCondition: json['bodyCondition'] as String?,
      bodyType: json['bodyType'] as String?,
      mechanicalCondition: json['mechanicalCondition'] as String?,
      seatingCapacity: json['seatingCapacity'] as int?,
      numofCylinders: json['numofCylinders'] as int?,
      transmissionType: json['transmissionType'] as String?,
      horsepower: json['horsepower'] as String?,
      fuelType: json['fuelType'] as String?,
      extras: json['extras'] as String?,
      technicalFeatures: json['technicalFeatures'] as String?,
      steeringSide: json['steeringSide'] as String?,
      guarantee: json['guarantee'] as bool?,
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
      'carImages': instance.carImages,
      'vedioUrl': instance.vedioUrl,
      'country': instance.country,
      'contactNumber': instance.contactNumber,
      'exteriorColor': instance.exteriorColor,
      'interiorColor': instance.interiorColor,
      'doors': instance.doors,
      'bodyCondition': instance.bodyCondition,
      'bodyType': instance.bodyType,
      'mechanicalCondition': instance.mechanicalCondition,
      'seatingCapacity': instance.seatingCapacity,
      'numofCylinders': instance.numofCylinders,
      'transmissionType': instance.transmissionType,
      'horsepower': instance.horsepower,
      'fuelType': instance.fuelType,
      'extras': instance.extras,
      'technicalFeatures': instance.technicalFeatures,
      'steeringSide': instance.steeringSide,
      'guarantee': instance.guarantee,
    };
