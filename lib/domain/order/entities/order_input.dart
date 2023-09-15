import 'package:equatable/equatable.dart';

class OrderInput extends Equatable {
  final String product;
  final double amount;
  final int qty;

  const OrderInput(
      {required this.product, required this.amount, required this.qty});
  @override
  List<Object?> get props => [product, amount, qty];
}
