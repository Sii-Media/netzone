// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departments_categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentsCategoryModel _$DepartmentsCategoryModelFromJson(
        Map<String, dynamic> json) =>
    DepartmentsCategoryModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String?,
      department: json['department'] as String?,
      imageUrl: json['imageUrl'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DepartmentsCategoryModelToJson(
        DepartmentsCategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'department': instance.department,
      'imageUrl': instance.imageUrl,
      'products': instance.products,
    };
