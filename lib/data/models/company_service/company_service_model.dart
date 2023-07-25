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
  final int price;
  final UserInfoModel owner;

  CompanyServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.owner,
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
      );
}
