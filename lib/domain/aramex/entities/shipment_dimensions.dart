import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/shipment_dimensions_model.dart';

class ShipmentDimensions extends Equatable {
  final int length;
  final int width;
  final int height;
  final String unit;

  const ShipmentDimensions(
      {required this.length,
      required this.width,
      required this.height,
      required this.unit});

  @override
  List<Object?> get props => [length, width, height, unit];
}

extension MapToDomain on ShipmentDimensions {
  ShipmentDimensionsModel fromDomain() => ShipmentDimensionsModel(
      length: length, width: width, height: height, unit: unit);
}
