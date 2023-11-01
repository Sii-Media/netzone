import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/processed_pickup.dart';

part 'processed_pickup_model.g.dart';

@JsonSerializable(createToJson: true)
class ProcessedPickupModel {
  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'GUID')
  final String guid;
  @JsonKey(name: 'Reference1')
  final String reference1;

  ProcessedPickupModel(
      {required this.id, required this.guid, required this.reference1});

  factory ProcessedPickupModel.fromJson(Map<String, dynamic> json) =>
      _$ProcessedPickupModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessedPickupModelToJson(this);
}

extension MapToDomain on ProcessedPickupModel {
  ProcessedPickup toDomain() =>
      ProcessedPickup(id: id, guid: guid, reference1: reference1);
}
