import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_details.dart';

part 'govermental_details_model.g.dart';

@JsonSerializable()
class GovermentalDetailsModel {
  @JsonKey(name: '_id')
  final String id;
  final String govname;
  final String name;
  final String imageUrl;
  final String city;
  final String address;
  final String email;
  final List<String> images;
  final String? phone;
  final String? mobile;
  final String info;
  final String? videourl;
  final String? link;

  GovermentalDetailsModel({
    required this.id,
    required this.govname,
    required this.name,
    required this.imageUrl,
    required this.city,
    required this.address,
    required this.email,
    required this.images,
    this.phone,
    this.mobile,
    required this.info,
    this.videourl,
    this.link,
  });

  factory GovermentalDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$GovermentalDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovermentalDetailsModelToJson(this);
}

extension MapToDomain on GovermentalDetailsModel {
  GovermentalDetails toDomain() => GovermentalDetails(
        id: id,
        govname: govname,
        name: name,
        imgurl: imageUrl,
        city: city,
        address: address,
        email: email,
        images: images,
        info: info,
        phone: phone,
        mobile: mobile,
        videourl: videourl,
        link: link,
      );
}
