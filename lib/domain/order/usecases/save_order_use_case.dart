import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/my_order.dart';
import '../entities/order_input.dart';
import '../repositories/order_repository.dart';

class SaveOrderUseCase extends UseCase<MyOrder, SaveOrderParams> {
  final OrderRepository orderRepository;

  SaveOrderUseCase({required this.orderRepository});
  @override
  Future<Either<Failure, MyOrder>> call(SaveOrderParams params) {
    return orderRepository.saveOrder(
      userId: params.userId,
      products: params.products,
      orderStatus: params.orderStatus,
      grandTotal: params.grandTotal,
      shippingAddress: params.shippingAddress,
      mobile: params.mobile,
      serviceFee: params.serviceFee,
      subTotal: params.subTotal,
    );
  }
}

class SaveOrderParams {
  final String userId;
  final List<OrderInput> products;
  final String orderStatus;
  final double grandTotal;
  final String? shippingAddress;
  final String? mobile;
  final double? subTotal;
  final double? serviceFee;

  SaveOrderParams({
    required this.userId,
    required this.products,
    required this.orderStatus,
    required this.grandTotal,
    this.shippingAddress,
    this.mobile,
    this.subTotal,
    this.serviceFee,
  });
}
