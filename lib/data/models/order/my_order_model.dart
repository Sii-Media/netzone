import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/order/entities/my_order.dart';

import 'order_products_model.dart';

part 'my_order_model.g.dart';

@JsonSerializable()
class MyOrderModel {
  @JsonKey(name: '_id')
  final String id;
  final String userId;
  final List<OrderProductsModel> products;
  final double grandTotal;
  final String? orderStatus;
  final String? createdAt;
  final String? updatedAt;

  MyOrderModel(
      {required this.id,
      required this.userId,
      required this.products,
      required this.grandTotal,
      this.orderStatus,
      this.createdAt,
      this.updatedAt});

  factory MyOrderModel.fromJson(Map<String, dynamic> json) =>
      _$MyOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrderModelToJson(this);
}

extension MapToDomain on MyOrderModel {
  MyOrder toDomain() => MyOrder(
        id: id,
        userId: userId,
        products: products.map((e) => e.toDomain()).toList(),
        grandTotal: grandTotal,
        orderStatus: orderStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
