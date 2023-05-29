import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/customs/customs_category_model.dart';
import 'package:netzoon/domain/categories/entities/customs/customs_company.dart';

part 'custom_companies_model.g.dart';

@JsonSerializable()
class CustomsCompaniesModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String imageUrl;
  final List<CustomsCategoryModel> customsplaces;

  CustomsCompaniesModel(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.customsplaces});

  factory CustomsCompaniesModel.fromJson(Map<String, dynamic> json) =>
      _$CustomsCompaniesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomsCompaniesModelToJson(this);
}

extension MapToDomain on CustomsCompaniesModel {
  CustomsCompanies toDomain() => CustomsCompanies(
        id: id,
        name: name,
        imageUrl: imageUrl,
        customsplaces: customsplaces.map((e) => e.toDomain()).toList(),
      );
}
