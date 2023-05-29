import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/govermental/govermental_details_model.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_companies.dart';

part 'govermental_companies_model.g.dart';

@JsonSerializable()
class GovermentalCompaniesModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String imageUrl;
  final List<GovermentalDetailsModel> govermentalCompanies;

  GovermentalCompaniesModel(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.govermentalCompanies});

  factory GovermentalCompaniesModel.fromJson(Map<String, dynamic> json) =>
      _$GovermentalCompaniesModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovermentalCompaniesModelToJson(this);
}

extension MapToDomain on GovermentalCompaniesModel {
  GovermentalCompanies toDomain() => GovermentalCompanies(
        id: id,
        name: name,
        imageUrl: imageUrl,
        govermentalCompanies:
            govermentalCompanies.map((e) => e.toDomain()).toList(),
      );
}
