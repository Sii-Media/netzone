import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../repositories/departments_repository.dart';

class DeleteFromSelectedProductsUseCase
    extends UseCase<String, DeleteFromSelectedProductsParams> {
  final DepartmentRepository departmentRepository;

  DeleteFromSelectedProductsUseCase({required this.departmentRepository});

  @override
  Future<Either<Failure, String>> call(
      DeleteFromSelectedProductsParams params) {
    return departmentRepository.deleteFromSelectedProducts(
        userId: params.userId, productId: params.productId);
  }
}

class DeleteFromSelectedProductsParams {
  final String userId;
  final String productId;

  DeleteFromSelectedProductsParams(
      {required this.userId, required this.productId});
}
