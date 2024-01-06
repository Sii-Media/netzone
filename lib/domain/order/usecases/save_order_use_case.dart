import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/order_input.dart';
import '../repositories/order_repository.dart';

class SaveOrderUseCase extends UseCase<String, SaveOrderParams> {
  final OrderRepository orderRepository;

  SaveOrderUseCase({required this.orderRepository});
  @override
  Future<Either<Failure, String>> call(SaveOrderParams params) {
    return orderRepository.saveOrder(
      userId: params.userId,
      clientId: params.clientId,
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
  final String clientId;
  final List<OrderInput> products;
  final String orderStatus;
  final double grandTotal;
  final String? shippingAddress;
  final String? mobile;
  final double? subTotal;
  final double? serviceFee;

  SaveOrderParams({
    required this.userId,
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
