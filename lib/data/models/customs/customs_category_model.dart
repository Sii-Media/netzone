import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/customs_category.dart';

part 'customs_category_model.g.dart';

@JsonSerializable()
class CustomsCategoryModel {
  @JsonKey(name: '_id')
  final String? id;
  final String categoryName;
  final String name;
  final String city;
  final String address;
  final String email;
  final String imgurl;
  final String info;
  final List<String> companyimages;
  final String? link;
  final String? videourl;

  CustomsCategoryModel({
    this.id,
    required this.categoryName,
    required this.name,
    required this.city,
    required this.address,
    required this.email,
    required this.imgurl,
    required this.info,
    required this.companyimages,
    this.link,
    this.videourl,
  });

  factory CustomsCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CustomsCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomsCategoryModelToJson(this);
}

extension MapToDomain on CustomsCategoryModel {
  CustomsCategory toDomain() => CustomsCategory(
        name: name,
        categoryName: categoryName,
        city: city,
        address: address,
        email: email,
        imgurl: imgurl,
        info: info,
        companyimages: companyimages,
        link: link,
        videourl: videourl,
      );
}
