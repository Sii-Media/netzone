import 'package:json_annotation/json_annotation.dart';

import '../../../domain/order/entities/order_produts.dart';
import '../departments/category_products/category_products_model.dart';

part 'order_products_model.g.dart';

@JsonSerializable()
class OrderProductsModel {
  @JsonKey(name: '_id')
  final String id;
  final CategoryProductsModel product;
  final double amount;
  final int qty;

  OrderProductsModel(
      {required this.id,
      required this.product,
      required this.amount,
      required this.qty});

  factory OrderProductsModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductsModelToJson(this);
}

extension MapToDomain on OrderProductsModel {
  OrderProducts toDomain() => OrderProducts(
        product: product.toDomain(),
        amount: amount,
        qty: qty,
        id: id,
      );
}
