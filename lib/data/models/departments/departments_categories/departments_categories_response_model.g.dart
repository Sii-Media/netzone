// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departments_categories_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentCategoryResponseModel _$DepartmentCategoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    DepartmentCategoryResponseModel(
      message: json['message'] as String,
      departmentCategories: (json['results'] as List<dynamic>)
          .map((e) =>
              DepartmentsCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepartmentCategoryResponseModelToJson(
        DepartmentCategoryResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.departmentCategories,
    };
