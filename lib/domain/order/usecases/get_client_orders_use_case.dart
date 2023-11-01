import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/order/entities/my_order.dart';
import 'package:netzoon/domain/order/repositories/order_repository.dart';

class GetClientOrdersUseCase extends UseCase<List<MyOrder>, String> {
  final OrderRepository orderRepository;

  GetClientOrdersUseCase({required this.orderRepository});

  @override
  Future<Either<Failure, List<MyOrder>>> call(String params) {
    return orderRepository.getClientOrders(clientId: params);
  }
}
