import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

import '../repositories/departments_repository.dart';

class GetAllProductsUseCase extends UseCase<List<CategoryProducts>, NoParams> {
  final DepartmentRepository departmentRepository;

  GetAllProductsUseCase({required this.departmentRepository});
  @override
  Future<Either<Failure, List<CategoryProducts>>> call(NoParams params) {
    return departmentRepository.getAllProducts();
  }
}
