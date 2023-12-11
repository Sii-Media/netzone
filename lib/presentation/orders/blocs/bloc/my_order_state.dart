part of 'my_order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class SaveOrderInProgress extends OrderState {}

class SaveOrderFailure extends OrderState {
  final String message;

  const SaveOrderFailure({required this.message});
}

class SaveOrderSuccess extends OrderState {
  final String order;

  const SaveOrderSuccess({required this.order});
}

class GetUserOrdersInProgress extends OrderState {}

class GetUserOrdersFailure extends OrderState {
  final String message;

  const GetUserOrdersFailure({required this.message});
}

class GetUserOrdersSuccess extends OrderState {
  final List<MyOrder> orderList;

  const GetUserOrdersSuccess({required this.orderList});
}

class GetClientOrdersInProgress extends OrderState {}

class GetClientOrdersFailure extends OrderState {
  final String message;

  const GetClientOrdersFailure({required this.message});
}

class GetClientOrdersSuccess extends OrderState {
  final List<MyOrder> orderList;

  const GetClientOrdersSuccess({required this.orderList});
}
