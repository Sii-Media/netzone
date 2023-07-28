import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/departments_repository.dart';

class RateProductUseCase extends UseCase<String, RateProductParams> {
  final DepartmentRepository departmentRepository;

  RateProductUseCase({required this.departmentRepository});

  @override
  Future<Either<Failure, String>> call(RateProductParams params) {
    return departmentRepository.rateProduct(
        id: params.id, rating: params.rating, userId: params.userId);
  }
}

class RateProductParams {
  final String id;
  final double rating;
  final String userId;

  RateProductParams(
      {required this.id, required this.rating, required this.userId});
}
