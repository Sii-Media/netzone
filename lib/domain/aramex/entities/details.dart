import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/shipment_details_model.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
import 'package:netzoon/domain/aramex/entities/shipment_items.dart';

class ShipmentDetails extends Equatable {
  final ActualWeight actualWeight;
  final String descriptionOfGoods;
  final String goodsOriginCountry;
  final int numberOfPieces;
  final String productGroup;
  final String productType;
  final String paymentType;
  final List<ShipmentItems>? items;
  const ShipmentDetails({
    required this.actualWeight,
    required this.descriptionOfGoods,
    required this.goodsOriginCountry,
    required this.numberOfPieces,
    required this.productGroup,
    required this.productType,
    required this.paymentType,
    this.items,
  });

  @override
  List<Object?> get props => [
        actualWeight,
        descriptionOfGoods,
        goodsOriginCountry,
        numberOfPieces,
        productGroup,
        productType,
        paymentType,
        items,
      ];
}

extension MapToDomain on ShipmentDetails {
  ShipmentDetailsModel fromDomain() => ShipmentDetailsModel(
        actualWeight: actualWeight.fromDomain(),
        descriptionOfGoods: descriptionOfGoods,
        goodsOriginCountry: goodsOriginCountry,
        numberOfPieces: numberOfPieces,
        productGroup: productGroup,
        productType: productType,
        paymentType: paymentType,
        items: items?.map((e) => e.fromDomain()).toList(),
      );
}
