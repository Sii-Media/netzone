import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/factories/factory_companies_model.dart';
import 'package:netzoon/domain/categories/entities/factories/factories_companies_reponse.dart';

part 'factory_companies_response_model.g.dart';

@JsonSerializable()
class FactoryCompaniesResponseModel {
  @JsonKey(name: 'factory')
  final List<FactoryCompaniesModel> factoryCompanies;

  FactoryCompaniesResponseModel({required this.factoryCompanies});

  factory FactoryCompaniesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryCompaniesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FactoryCompaniesResponseModelToJson(this);
}

extension MapToDomain on FactoryCompaniesResponseModel {
  FactoriesCompaniesResponse toDomain() => FactoriesCompaniesResponse(
      factories: factoryCompanies.map((e) => e.toDomain()).toList());
}
