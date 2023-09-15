part of 'my_order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class SaveOrderEvent extends OrderEvent {
  final List<OrderInput> products;
  final String orderStatus;
  final double grandTotal;

  const SaveOrderEvent(
      {required this.products,
      required this.orderStatus,
      required this.grandTotal});
}

class GetUserOrdersEvent extends OrderEvent {}
