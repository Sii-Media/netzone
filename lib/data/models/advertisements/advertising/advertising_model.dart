import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/advertisements/advertisements/advertiement_model.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';

part 'advertising_model.g.dart';

@JsonSerializable()
class AdvertisingModel {
  final String message;

  @JsonKey(name: 'results')
  final List<AdvertisemenetModel> advertisemenetModel;

  AdvertisingModel({
    required this.message,
    required this.advertisemenetModel,
  });

  factory AdvertisingModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertisingModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisingModelToJson(this);
}

extension MapToDomain on AdvertisingModel {
  Advertising toDomain() => Advertising(
      message: message,
      advertisement: advertisemenetModel.map((e) => e.toDomain()).toList());
}
