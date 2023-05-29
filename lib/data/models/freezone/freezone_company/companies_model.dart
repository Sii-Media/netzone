import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company.dart';

part 'companies_model.g.dart';

@JsonSerializable()
class CompaniesModel {
  final String name;
  final String image;

  CompaniesModel({required this.name, required this.image});

  factory CompaniesModel.fromJson(Map<String, dynamic> json) =>
      _$CompaniesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompaniesModelToJson(this);
}

extension MapToDomain on CompaniesModel {
  Companies toDomain() => Companies(name: name, image: image);
}
