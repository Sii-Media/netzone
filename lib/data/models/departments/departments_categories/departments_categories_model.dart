import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';

part 'departments_categories_model.g.dart';

@JsonSerializable()
class DepartmentsCategoryModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String? department;
  final String? imageUrl;
  final List<String>? products;

  DepartmentsCategoryModel({
    this.id,
    required this.name,
    this.department,
    this.imageUrl,
    this.products,
  });

  factory DepartmentsCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentsCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentsCategoryModelToJson(this);
}

extension MapToDomain on DepartmentsCategoryModel {
  DepartmentsCategories toDomain() => DepartmentsCategories(
        id: id,
        name: name,
        department: department,
        imageUrl: imageUrl,
        products: products,
      );
}
