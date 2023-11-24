import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/company_service/company_service_model.dart';
import 'package:netzoon/domain/company_service/service_category.dart';

part 'service_category_model.g.dart';

@JsonSerializable()
class ServiceCategoryModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final List<CompanyServiceModel>? services;

  ServiceCategoryModel(
      {required this.id, required this.title, required this.services});

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceCategoryModelToJson(this);
}

extension MapToDomain on ServiceCategoryModel {
  ServiceCategory toDomain() => ServiceCategory(
        id: id,
        title: title,
        services: services?.map((e) => e.toDomain()).toList(),
      );
}
