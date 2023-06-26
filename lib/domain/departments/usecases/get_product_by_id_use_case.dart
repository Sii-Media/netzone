import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../entities/category_products/category_products.dart';
import '../repositories/departments_repository.dart';

class GetProductByIdUseCase extends UseCase<CategoryProducts, String> {
  final DepartmentRepository departmentRepository;

  GetProductByIdUseCase({required this.departmentRepository});
  @override
  Future<Either<Failure, CategoryProducts>> call(String params) {
    return departmentRepository.getProductById(productId: params);
  }
}
