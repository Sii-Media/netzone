import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../entities/delivery_service/delivery_service.dart';

abstract class DeliveryServiceRepository {
  Future<Either<Failure, List<DeliveryService>>> getDeliveryCompanyServices({
    required String id,
  });

  Future<Either<Failure, String>> addDeliveryService({
    required String title,
    required String description,
    required String from,
    required String to,
    required int price,
    required String owner,
  });
}
