import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/actual_weight_model.dart';
import 'package:netzoon/domain/aramex/entities/rate_shipment_details.dart';

part 'rate_shipment_details_model.g.dart';

@JsonSerializable(createToJson: true)
class RateShipmentDetailsModel {
  @JsonKey(name: 'ActualWeight')
  final ActualWeightModel actualWeight;
  @JsonKey(name: 'ChargeableWeight')
  final ActualWeightModel chargeableWeight;
  @JsonKey(name: 'NumberOfPieces')
  final int numberOfPieces;
  @JsonKey(name: 'ProductGroup')
  final String productGroup;
  @JsonKey(name: 'ProductType')
  final String productType;
  @JsonKey(name: 'PaymentType')
  final String paymentType;
  @JsonKey(name: 'Services')
  final String services;

  RateShipmentDetailsModel(
      {required this.actualWeight,
      required this.chargeableWeight,
      required this.numberOfPieces,
      required this.productGroup,
      required this.productType,
      required this.paymentType,
      required this.services});

  factory RateShipmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RateShipmentDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RateShipmentDetailsModelToJson(this);
}

extension MapToDomain on RateShipmentDetailsModel {
  RateShipmentDetails toDomain() => RateShipmentDetails(
      actualWeight: actualWeight.toDomain(),
      chargeableWeight: chargeableWeight.toDomain(),
      numberOfPieces: numberOfPieces,
      productGroup: productGroup,
      productType: productType,
      paymentType: paymentType);
}
