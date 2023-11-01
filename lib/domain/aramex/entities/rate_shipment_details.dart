import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/rate_shipment_details_model.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';

class RateShipmentDetails extends Equatable {
  final ActualWeight actualWeight;
  final ActualWeight chargeableWeight;

  final int numberOfPieces;
  final String productGroup;
  final String productType;
  final String paymentType;
  final String services;

  const RateShipmentDetails(
      {required this.actualWeight,
      required this.chargeableWeight,
      required this.numberOfPieces,
      required this.productGroup,
      required this.productType,
      required this.paymentType,
      this.services = ""});
  @override
  List<Object?> get props => [
        actualWeight,
        chargeableWeight,
        numberOfPieces,
        productGroup,
        productType,
        paymentType,
        services
      ];
}

extension MapToDomain on RateShipmentDetails {
  RateShipmentDetailsModel fromDomain() => RateShipmentDetailsModel(
      actualWeight: actualWeight.fromDomain(),
      chargeableWeight: chargeableWeight.fromDomain(),
      numberOfPieces: numberOfPieces,
      productGroup: productGroup,
      productType: productType,
      paymentType: paymentType,
      services: services);
}
