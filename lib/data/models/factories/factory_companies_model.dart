import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/factories/factory_companies.dart';

part 'factory_companies_model.g.dart';

@JsonSerializable()
class FactoryCompaniesModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String imgurl;

  FactoryCompaniesModel(
      {required this.id, required this.name, required this.imgurl});

  factory FactoryCompaniesModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryCompaniesModelFromJson(json);

  Map<String, dynamic> toJson() => _$FactoryCompaniesModelToJson(this);
}

extension MapToDomain on FactoryCompaniesModel {
  FactoryCompanies toDomain() =>
      FactoryCompanies(id: id, name: name, imgurl: imgurl);
}
