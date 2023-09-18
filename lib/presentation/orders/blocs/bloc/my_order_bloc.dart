import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/order/usecases/get_user_orders_use_case.dart';
import 'package:netzoon/domain/order/usecases/save_order_use_case.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/core/usecase/usecase.dart';
import '../../../../domain/order/entities/my_order.dart';
import '../../../../domain/order/entities/order_input.dart';
import '../../../core/helpers/map_failure_to_string.dart';

part 'my_order_event.dart';
part 'my_order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final SaveOrderUseCase saveOrderUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final GetUserOrdersUseCase getUserOrdersUseCase;
  OrderBloc({
    required this.saveOrderUseCase,
    required this.getSignedInUser,
    required this.getUserOrdersUseCase,
  }) : super(OrderInitial()) {
    on<SaveOrderEvent>((event, emit) async {
      emit(SaveOrderInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final order = await saveOrderUseCase(
        SaveOrderParams(
          userId: user.userInfo.id,
          products: event.products,
          orderStatus: event.orderStatus,
          grandTotal: event.grandTotal,
          shippingAddress: event.shippingAddress,
          mobile: event.mobile,
          serviceFee: event.serviceFee,
          subTotal: event.subTotal,
        ),
      );
      emit(
        order.fold(
            (failure) => SaveOrderFailure(message: mapFailureToString(failure)),
            (order) => SaveOrderSuccess(order: order)),
      );
    });
    on<GetUserOrdersEvent>((event, emit) async {
      emit(GetUserOrdersInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final orders = await getUserOrdersUseCase(user.userInfo.id);
      emit(
        orders.fold(
          (failure) =>
              GetUserOrdersFailure(message: mapFailureToString(failure)),
          (orderList) => GetUserOrdersSuccess(
            orderList: orderList,
          ),
        ),
      );
    });
  }
}
