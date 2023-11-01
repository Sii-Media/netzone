import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/shipment_dimensions.dart';

part 'shipment_dimensions_model.g.dart';

@JsonSerializable(createToJson: true)
class ShipmentDimensionsModel {
  @JsonKey(name: 'Length')
  final int length;
  @JsonKey(name: 'Width')
  final int width;
  @JsonKey(name: 'Height')
  final int height;
  @JsonKey(name: 'Unit')
  final String unit;

  ShipmentDimensionsModel(
      {required this.length,
      required this.width,
      required this.height,
      required this.unit});

  factory ShipmentDimensionsModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDimensionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentDimensionsModelToJson(this);
}

extension MapToDomain on ShipmentDimensionsModel {
  ShipmentDimensions toDomain() => ShipmentDimensions(
      length: length, width: width, height: height, unit: unit);
}
