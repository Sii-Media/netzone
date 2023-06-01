// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryProductsModel _$CategoryProductsModelFromJson(
        Map<String, dynamic> json) =>
    CategoryProductsModel(
      id: json['_id'] as String,
      owner: json['owner'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      vedioUrl: json['vedioUrl'] as String?,
      guarantee: json['guarantee'] as bool?,
      propert: json['propert'] as String?,
      madeIn: json['madeIn'] as String?,
      year: json['year'] as String?,
    );

Map<String, dynamic> _$CategoryProductsModelToJson(
        CategoryProductsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'description': instance.description,
      'price': instance.price,
      'images': instance.images,
      'vedioUrl': instance.vedioUrl,
      'guarantee': instance.guarantee,
      'propert': instance.propert,
      'madeIn': instance.madeIn,
      'year': instance.year,
    };
