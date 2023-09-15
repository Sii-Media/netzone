import 'package:equatable/equatable.dart';

import 'order_produts.dart';

class MyOrder extends Equatable {
  final String id;
  final String userId;
  final List<OrderProducts> products;
  final double grandTotal;
  final String? orderStatus;
  final String? createdAt;
  final String? updatedAt;

  const MyOrder(
      {required this.id,
      required this.userId,
      required this.products,
      required this.grandTotal,
      this.orderStatus,
      this.createdAt,
      this.updatedAt});

  @override
  List<Object?> get props =>
      [id, userId, products, grandTotal, orderStatus, createdAt, updatedAt];
}
