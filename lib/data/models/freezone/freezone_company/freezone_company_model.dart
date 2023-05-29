import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/freezone/freezone_company/companies_model.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company.dart';

part 'freezone_company_model.g.dart';

@JsonSerializable()
class FreeZoneCompanyModel {
  @JsonKey(name: '_id')
  final String? id;
  final String categoryName;
  final String name;
  final String city;
  final String address;
  final String email;
  final String imgurl;
  final String? phone;
  final String? mobile;
  final List<CompaniesModel>? companies;
  final String info;
  final List<String> companyimages;
  final String? videourl;
  final String? link;

  FreeZoneCompanyModel({
    this.id,
    required this.categoryName,
    required this.name,
    required this.city,
    required this.address,
    required this.email,
    required this.imgurl,
    this.phone,
    this.mobile,
    this.companies,
    required this.info,
    required this.companyimages,
    this.videourl,
    this.link,
  });

  factory FreeZoneCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$FreeZoneCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreeZoneCompanyModelToJson(this);
}

extension MapToDomain on FreeZoneCompanyModel {
  FreeZoneCompany toDomain() => FreeZoneCompany(
        categoryName: categoryName,
        name: name,
        city: city,
        address: address,
        email: email,
        imgurl: imgurl,
        phone: phone,
        mobile: mobile,
        companies: companies?.map((e) => e.toDomain()).toList(),
        info: info,
        companyimages: companyimages,
        videourl: videourl,
        link: link,
      );
}
