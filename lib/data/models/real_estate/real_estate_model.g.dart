// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_estate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealEstateModel _$RealEstateModelFromJson(Map<String, dynamic> json) =>
    RealEstateModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      location: json['location'] as String,
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdBy:
          UserInfoModel.fromJson(json['createdBy'] as Map<String, dynamic>),
      country: json['country'] as String,
      type: json['type'] as String?,
      category: json['category'] as String?,
      forWhat: json['forWhat'] as String?,
      furnishing: json['furnishing'] as bool?,
    );

Map<String, dynamic> _$RealEstateModelToJson(RealEstateModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'price': instance.price,
      'area': instance.area,
      'location': instance.location,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'amenities': instance.amenities,
      'images': instance.images,
      'createdBy': instance.createdBy,
      'country': instance.country,
      'type': instance.type,
      'category': instance.category,
      'forWhat': instance.forWhat,
      'furnishing': instance.furnishing,
    };
