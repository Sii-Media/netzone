import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/my_order.dart';
import '../repositories/order_repository.dart';

class GetUserOrdersUseCase extends UseCase<List<MyOrder>, String> {
  final OrderRepository orderRepository;

  GetUserOrdersUseCase({required this.orderRepository});
  @override
  Future<Either<Failure, List<MyOrder>>> call(String params) {
    return orderRepository.getUserOrders(userId: params);
  }
}
