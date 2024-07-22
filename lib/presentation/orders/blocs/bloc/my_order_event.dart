part of 'my_order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class SaveOrderEvent extends OrderEvent {
  final String clientId;
  final List<OrderInput> products;
  final String orderStatus;
  final double grandTotal;
  final String? shippingAddress;
  final String? mobile;
  final double? subTotal;
  final double? serviceFee;
  const SaveOrderEvent({
    required this.clientId,
    required this.products,
    required this.orderStatus,
    required this.grandTotal,
    this.shippingAddress,
    this.mobile,
    this.subTotal,
    this.serviceFee,
  });
}

class GetUserOrdersEvent extends OrderEvent {}

class GetClientOrdersEvent extends OrderEvent {}

class UpdateOrderPickupEvent extends OrderEvent {
  final String id;
  final String pickupId;

  const UpdateOrderPickupEvent({required this.id, required this.pickupId});
}
