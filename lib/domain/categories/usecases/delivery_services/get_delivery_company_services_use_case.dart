import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/delivery_service/delivery_service.dart';
import 'package:netzoon/domain/categories/repositories/delivery_service_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetDeliveryCompanyServicesUseCase
    extends UseCase<List<DeliveryService>, String> {
  final DeliveryServiceRepository deliveryServiceRepository;

  GetDeliveryCompanyServicesUseCase({required this.deliveryServiceRepository});
  @override
  Future<Either<Failure, List<DeliveryService>>> call(String params) {
    return deliveryServiceRepository.getDeliveryCompanyServices(id: params);
  }
}
