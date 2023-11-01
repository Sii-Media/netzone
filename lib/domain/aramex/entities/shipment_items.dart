import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/shipment_items_model.dart';
import 'package:netzoon/domain/aramex/entities/actual_weight.dart';
import 'package:netzoon/domain/aramex/entities/total_amount.dart';

class ShipmentItems extends Equatable {
  final String packageType;
  final int quantity;
  final ActualWeight weight;
  final String comments;
  final String reference;
  final int commodityCode;
  final String goodsDescription;
  final String countryOfOrigin;
  final TotalAmount customsValue;

  const ShipmentItems(
      {required this.packageType,
      required this.quantity,
      required this.weight,
      required this.comments,
      required this.reference,
      required this.commodityCode,
      required this.goodsDescription,
      required this.countryOfOrigin,
      required this.customsValue});

  @override
  List<Object?> get props => [
        packageType,
        quantity,
        weight,
        comments,
        reference,
        commodityCode,
        goodsDescription,
        countryOfOrigin,
        customsValue,
      ];
}

extension MapToDomain on ShipmentItems {
  ShipmentItemsModel fromDomain() => ShipmentItemsModel(
      packageType: packageType,
      quantity: quantity,
      weight: weight.fromDomain(),
      comments: comments,
      reference: reference,
      commodityCode: commodityCode,
      goodsDescription: goodsDescription,
      countryOfOrigin: countryOfOrigin,
      customsValue: customsValue.fromDomain());
}
