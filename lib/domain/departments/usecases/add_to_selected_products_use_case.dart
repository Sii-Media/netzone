import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../repositories/departments_repository.dart';

class AddToSelectedProductsUseCase
    extends UseCase<String, AddToSelectedProductsParams> {
  final DepartmentRepository departmentRepository;

  AddToSelectedProductsUseCase({required this.departmentRepository});

  @override
  Future<Either<Failure, String>> call(AddToSelectedProductsParams params) {
    return departmentRepository.addToSelectedProducts(
        userId: params.userId, productIds: params.productIds);
  }
}

class AddToSelectedProductsParams {
  final String userId;
  final List<String> productIds;

  AddToSelectedProductsParams({required this.userId, required this.productIds});
}
