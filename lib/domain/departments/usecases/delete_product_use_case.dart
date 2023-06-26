import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/departments_repository.dart';

class DeleteProductUseCase extends UseCase<String, String> {
  final DepartmentRepository departmentRepository;

  DeleteProductUseCase({required this.departmentRepository});

  @override
  Future<Either<Failure, String>> call(String params) {
    return departmentRepository.deleteProduct(productId: params);
  }
}
