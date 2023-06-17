import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicles_companies.dart';

part 'vehicles_companies_model.g.dart';

@JsonSerializable()
class VehiclesCompaniesModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String type;
  final String imgUrl;
  final String description;
  final String bio;
  final String mobile;
  final String mail;
  final String website;
  final String? coverUrl;

  VehiclesCompaniesModel(
      {this.id,
      required this.name,
      required this.type,
      required this.imgUrl,
      required this.description,
      required this.bio,
      required this.mobile,
      required this.mail,
      required this.website,
      this.coverUrl});

  factory VehiclesCompaniesModel.fromJson(Map<String, dynamic> json) =>
      _$VehiclesCompaniesModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclesCompaniesModelToJson(this);
}

extension MapToDomain on VehiclesCompaniesModel {
  VehiclesCompanies toDomain() => VehiclesCompanies(
        id: id ?? '',
        name: name,
        type: type,
        imgUrl: imgUrl,
        description: description,
        bio: bio,
        mobile: mobile,
        mail: mail,
        website: website,
        coverUrl: coverUrl,
      );
}
