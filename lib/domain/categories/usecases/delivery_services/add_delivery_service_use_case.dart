import 'package:netzoon/domain/categories/repositories/delivery_service_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class AddDeliveryServiceUseCase
    extends UseCase<String, AddDeliveryServiceParams> {
  final DeliveryServiceRepository deliveryServiceRepository;

  AddDeliveryServiceUseCase({required this.deliveryServiceRepository});
  @override
  Future<Either<Failure, String>> call(AddDeliveryServiceParams params) {
    return deliveryServiceRepository.addDeliveryService(
        title: params.title,
        description: params.description,
        from: params.from,
        to: params.to,
        price: params.price,
        owner: params.owner);
  }
}

class AddDeliveryServiceParams {
  final String title;
  final String description;
  final String from;
  final String to;
  final int price;
  final String owner;

  AddDeliveryServiceParams({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.price,
    required this.owner,
  });
}
