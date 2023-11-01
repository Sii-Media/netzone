import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/actual_weight_model.dart';
import 'package:netzoon/data/models/aramex/total_amount_model.dart';
import 'package:netzoon/domain/aramex/entities/shipment_items.dart';

part 'shipment_items_model.g.dart';

@JsonSerializable(createToJson: true)
class ShipmentItemsModel {
  @JsonKey(name: 'PackageType')
  final String packageType;
  @JsonKey(name: 'Quantity')
  final int quantity;
  @JsonKey(name: 'Weight')
  final ActualWeightModel weight;
  @JsonKey(name: 'Comments')
  final String comments;

  @JsonKey(name: 'Reference')
  final String reference;

  @JsonKey(name: 'CommodityCode')
  final int commodityCode;
  @JsonKey(name: 'GoodsDescription')
  final String goodsDescription;

  @JsonKey(name: 'CountryOfOrigin')
  final String countryOfOrigin;
  @JsonKey(name: 'CustomsValue')
  final TotalAmountModel customsValue;

  ShipmentItemsModel(
      {required this.packageType,
      required this.quantity,
      required this.weight,
      required this.comments,
      required this.reference,
      required this.commodityCode,
      required this.goodsDescription,
      required this.countryOfOrigin,
      required this.customsValue});

  factory ShipmentItemsModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentItemsModelToJson(this);
}

extension MapToDomain on ShipmentItemsModel {
  ShipmentItems toDomain() => ShipmentItems(
      packageType: packageType,
      quantity: quantity,
      weight: weight.toDomain(),
      comments: comments,
      reference: reference,
      commodityCode: commodityCode,
      goodsDescription: goodsDescription,
      countryOfOrigin: countryOfOrigin,
      customsValue: customsValue.toDomain());
}
