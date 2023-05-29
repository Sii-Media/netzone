import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';

part 'local_company_model.g.dart';

@JsonSerializable()
class LocalCompanyModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String imgUrl;
  final String description;
  final String desc2;
  final String mobile;
  final String mail;
  final String website;
  final List<String> docs;

  LocalCompanyModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.desc2,
    required this.mobile,
    required this.mail,
    required this.website,
    required this.docs,
  });

  factory LocalCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$LocalCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalCompanyModelToJson(this);
}

extension MapToDomain on LocalCompanyModel {
  LocalCompany toDomain() => LocalCompany(
        id: id,
        name: name,
        imgUrl: imgUrl,
        description: description,
        desc2: desc2,
        mobile: mobile,
        mail: mail,
        website: website,
        docs: docs,
      );
}
