import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company_category.dart';

part 'local_company_category_model.g.dart';

@JsonSerializable()
class LocalCompanyCategoryModel {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name_en')
  final String nameEn;
  @JsonKey(name: 'name_ar')
  final String nameAr;

  LocalCompanyCategoryModel(
      {required this.id, required this.nameEn, required this.nameAr});
  factory LocalCompanyCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$LocalCompanyCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalCompanyCategoryModelToJson(this);
}

extension MapToDomain on LocalCompanyCategoryModel {
  LocalCompanyCategory toDomain() =>
      LocalCompanyCategory(id: id, nameEn: nameEn, nameAr: nameAr);
}
