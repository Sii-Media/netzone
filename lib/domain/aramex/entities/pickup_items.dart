import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/pickup_items_model.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
import 'package:netzoon/domain/aramex/entities/shipment_dimensions.dart';

class PickupItems extends Equatable {
  final String productGroup;
  final String productType;
  final int numberOfShipments;
  final String packageTypel;
  final String payment;
  final ActualWeight shipmentWeight;
  final int numberOfPieces;
  final String comments;
  final ShipmentDimensions shipmentDimensions;

  const PickupItems(
      {required this.productGroup,
      required this.productType,
      required this.numberOfShipments,
      required this.packageTypel,
      required this.payment,
      required this.shipmentWeight,
      required this.numberOfPieces,
      required this.shipmentDimensions,
      required this.comments});

  @override
  List<Object?> get props => [
        productGroup,
        productType,
        numberOfShipments,
        packageTypel,
        payment,
        shipmentWeight,
        numberOfPieces,
        shipmentDimensions,
        comments
      ];
}

extension MapToDomain on PickupItems {
  PickUpItemsModel fromDomain() => PickUpItemsModel(
      productGroup: productGroup,
      productType: productType,
      numberOfShipments: numberOfShipments,
      packageTypel: packageTypel,
      payment: payment,
      shipmentWeight: shipmentWeight.fromDomain(),
      numberOfPieces: numberOfPieces,
      shipmentDimensions: shipmentDimensions.fromDomain(),
      comments: comments);
}
