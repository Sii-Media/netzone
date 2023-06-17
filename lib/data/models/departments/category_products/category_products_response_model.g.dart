// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_products_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryProductsResponseModel _$CategoryProductsResponseModelFromJson(
        Map<String, dynamic> json) =>
    CategoryProductsResponseModel(
      department: json['department'] as String,
      category: json['category'] as String,
      message: json['message'] as String,
      categoryProducts: (json['results'] as List<dynamic>)
          .map((e) => CategoryProductsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryProductsResponseModelToJson(
        CategoryProductsResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'department': instance.department,
      'category': instance.category,
      'results': instance.categoryProducts,
    };
