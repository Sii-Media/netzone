import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/my_order.dart';
import '../entities/order_input.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<MyOrder>>> getUserOrders({
    required final String userId,
  });

  Future<Either<Failure, String>> saveOrder({
    required final String userId,
    required final String clientId,
    required final List<OrderInput> products,
    required final String orderStatus,
    required final double grandTotal,
    required final String? shippingAddress,
    required final String? mobile,
    required final double? subTotal,
    required final double? serviceFee,
  });

  Future<Either<Failure, List<MyOrder>>> getClientOrders({
    required final String clientId,
  });

  Future<Either<Failure, String>> updateOrderPickup({
    required final String id,
    required final String pickupId,
  });
}
