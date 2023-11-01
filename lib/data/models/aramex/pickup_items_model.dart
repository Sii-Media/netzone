import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/actual_weight_model.dart';
import 'package:netzoon/data/models/aramex/shipment_dimensions_model.dart';
import 'package:netzoon/domain/aramex/entities/pickup_items.dart';

part 'pickup_items_model.g.dart';

@JsonSerializable(createToJson: true)
class PickUpItemsModel {
  @JsonKey(name: 'ProductGroup')
  final String productGroup;

  @JsonKey(name: 'ProductType')
  final String productType;

  @JsonKey(name: 'NumberOfShipments')
  final int numberOfShipments;

  @JsonKey(name: 'PackageTypel')
  final String packageTypel;

  @JsonKey(name: 'Payment')
  final String payment;

  @JsonKey(name: 'ShipmentWeight')
  final ActualWeightModel shipmentWeight;

  @JsonKey(name: 'NumberOfPieces')
  final int numberOfPieces;

  @JsonKey(name: 'ShipmentDimensions')
  final ShipmentDimensionsModel shipmentDimensions;

  @JsonKey(name: 'Comments')
  final String comments;

  PickUpItemsModel(
      {required this.productGroup,
      required this.productType,
      required this.numberOfShipments,
      required this.packageTypel,
      required this.payment,
      required this.shipmentWeight,
      required this.numberOfPieces,
      required this.shipmentDimensions,
      required this.comments});

  factory PickUpItemsModel.fromJson(Map<String, dynamic> json) =>
      _$PickUpItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PickUpItemsModelToJson(this);
}

extension MapToDomain on PickUpItemsModel {
  PickupItems toDomain() => PickupItems(
      productGroup: productGroup,
      productType: productType,
      numberOfShipments: numberOfShipments,
      packageTypel: packageTypel,
      payment: payment,
      shipmentWeight: shipmentWeight.toDomain(),
      numberOfPieces: numberOfPieces,
      shipmentDimensions: shipmentDimensions.toDomain(),
      comments: comments);
}
