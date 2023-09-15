import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/my_order.dart';
import '../entities/order_input.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<MyOrder>>> getUserOrders({
    required final String userId,
  });

  Future<Either<Failure, MyOrder>> saveOrder({
    required final String userId,
    required final List<OrderInput> products,
    required final String orderStatus,
    required final double grandTotal,
  });
}
