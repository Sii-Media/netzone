import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/company_service/company_service.dart';

part 'company_service_model.g.dart';

@JsonSerializable()
class CompanyServiceModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final int? price;
  final UserInfoModel owner;
  final String? imageUrl;
  final List<String>? serviceImageList;
  final String? whatsAppNumber;
  final double? averageRating;
  final double? totalRatings;

  CompanyServiceModel({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    required this.owner,
    this.imageUrl,
    this.serviceImageList,
    this.whatsAppNumber,
    this.averageRating,
    this.totalRatings,
  });

  factory CompanyServiceModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyServiceModelToJson(this);
}

extension MapToDomain on CompanyServiceModel {
  CompanyService toDomain() => CompanyService(
        id: id,
        title: title,
        description: description,
        price: price,
        owner: owner.toDomain(),
        imageUrl: imageUrl,
        serviceImageList: serviceImageList,
        whatsAppNumber: whatsAppNumber,
        averageRating: averageRating,
        totalRatings: totalRatings,
      );
}
