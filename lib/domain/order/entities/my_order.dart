import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

import 'order_produts.dart';

class MyOrder extends Equatable {
  final String id;
  final UserInfo userId;
  final UserInfo clientId;
  final List<OrderProducts> products;
  final double grandTotal;
  final String? orderStatus;
  final String? shippingAddress;
  final String? mobile;
  final double? subTotal;
  final double? serviceFee;

  final String? createdAt;
  final String? updatedAt;

  const MyOrder(
      {required this.id,
      required this.userId,
      required this.clientId,
      required this.products,
      required this.grandTotal,
      this.orderStatus,
      this.shippingAddress,
      this.mobile,
      this.subTotal,
      this.serviceFee,
      this.createdAt,
      this.updatedAt});

  @override
  List<Object?> get props => [
        id,
        userId,
        clientId,
        products,
        grandTotal,
        orderStatus,
        createdAt,
        updatedAt
      ];
}
