import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/categories/entities/delivery_service/delivery_service.dart';

part 'delivery_service_model.g.dart';

@JsonSerializable()
class DeliveryServiceModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final String from;
  final String to;
  final int price;
  final UserInfoModel owner;

  DeliveryServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.price,
    required this.owner,
  });

  factory DeliveryServiceModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryServiceModelToJson(this);
}

extension MapToDomain on DeliveryServiceModel {
  DeliveryService toDomain() => DeliveryService(
      id: id,
      title: title,
      description: description,
      from: from,
      to: to,
      price: price,
      owner: owner.toDomain());
}
