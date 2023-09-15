import 'package:equatable/equatable.dart';

import '../../departments/entities/category_products/category_products.dart';

class OrderProducts extends Equatable {
  final CategoryProducts product;
  final double amount;
  final int qty;
  final String id;

  const OrderProducts(
      {required this.product,
      required this.amount,
      required this.qty,
      required this.id});

  @override
  List<Object?> get props => [product, amount, qty, id];
}
