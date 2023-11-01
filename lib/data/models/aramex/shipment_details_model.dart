import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/actual_weight_model.dart';
import 'package:netzoon/data/models/aramex/shipment_items_model.dart';
import 'package:netzoon/domain/aramex/entities/details.dart';

part 'shipment_details_model.g.dart';

@JsonSerializable(createToJson: true)
class ShipmentDetailsModel {
  @JsonKey(name: 'ActualWeight')
  final ActualWeightModel actualWeight;

  @JsonKey(name: 'DescriptionOfGoods')
  final String descriptionOfGoods;

  @JsonKey(name: 'GoodsOriginCountry')
  final String goodsOriginCountry;

  @JsonKey(name: 'NumberOfPieces')
  final int numberOfPieces;

  @JsonKey(name: 'ProductGroup')
  final String productGroup;

  @JsonKey(name: 'ProductType')
  final String productType;

  @JsonKey(name: 'PaymentType')
  final String paymentType;

  @JsonKey(name: 'Items')
  final List<ShipmentItemsModel>? items;

  ShipmentDetailsModel({
    required this.actualWeight,
    required this.descriptionOfGoods,
    required this.goodsOriginCountry,
    required this.numberOfPieces,
    required this.productGroup,
    required this.productType,
    required this.paymentType,
    this.items,
  });

  factory ShipmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentDetailsModelToJson(this);
}

extension MapToDomain on ShipmentDetailsModel {
  ShipmentDetails toDomain() => ShipmentDetails(
      actualWeight: actualWeight.toDomain(),
      descriptionOfGoods: descriptionOfGoods,
      goodsOriginCountry: goodsOriginCountry,
      numberOfPieces: numberOfPieces,
      productGroup: productGroup,
      productType: productType,
      paymentType: paymentType,
      items: items?.map((e) => e.toDomain()).toList());
}
