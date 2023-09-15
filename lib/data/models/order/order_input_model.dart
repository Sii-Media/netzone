import 'package:json_annotation/json_annotation.dart';

import '../../../domain/order/entities/order_input.dart';

part 'order_input_model.g.dart';

@JsonSerializable()
class OrderInputModel {
  final String product;
  final double amount;
  final int qty;

  OrderInputModel(
      {required this.product, required this.amount, required this.qty});

  factory OrderInputModel.fromJson(Map<String, dynamic> json) =>
      _$OrderInputModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInputModelToJson(this);
}

extension MapToDomain on OrderInputModel {
  OrderInput toDomain() =>
      OrderInput(product: product, amount: amount, qty: qty);
}
