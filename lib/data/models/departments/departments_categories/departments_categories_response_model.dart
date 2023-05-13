import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/departments/departments_categories/departments_categories_model.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories_response.dart';

part 'departments_categories_response_model.g.dart';

@JsonSerializable()
class DepartmentCategoryResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final List<DepartmentsCategoryModel> departmentCategories;

  DepartmentCategoryResponseModel({
    required this.message,
    required this.departmentCategories,
  });

  factory DepartmentCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentCategoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DepartmentCategoryResponseModelToJson(this);
}

extension MapToDomain on DepartmentCategoryResponseModel {
  DepartmentsCategoriesResponse toDomain() => DepartmentsCategoriesResponse(
        message: message,
        departmentsCat: departmentCategories.map((e) => e.toDomain()).toList(),
      );
}
