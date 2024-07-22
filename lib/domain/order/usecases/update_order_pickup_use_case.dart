import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/order/repositories/order_repository.dart';

class UpdateOrderPickupUseCase
    extends UseCase<String, UpdateOrderPickupParams> {
  final OrderRepository orderRepository;

  UpdateOrderPickupUseCase({required this.orderRepository});
  @override
  Future<Either<Failure, String>> call(UpdateOrderPickupParams params) {
    return orderRepository.updateOrderPickup(
        id: params.id, pickupId: params.pickupId);
  }
}

class UpdateOrderPickupParams {
  final String id;
  final String pickupId;

  UpdateOrderPickupParams({required this.id, required this.pickupId});
}
