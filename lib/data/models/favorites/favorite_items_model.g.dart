// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteItemsModel _$FavoriteItemsModelFromJson(Map<String, dynamic> json) =>
    FavoriteItemsModel(
      id: json['productId'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      category: json['category'] as String,
    );

Map<String, dynamic> _$FavoriteItemsModelToJson(FavoriteItemsModel instance) =>
    <String, dynamic>{
      'productId': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
    };
