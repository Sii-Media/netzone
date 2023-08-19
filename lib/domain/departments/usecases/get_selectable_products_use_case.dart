import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../entities/category_products/category_products.dart';
import '../repositories/departments_repository.dart';

class GetSelectableProductsUseCase
    extends UseCase<List<CategoryProducts>, String> {
  final DepartmentRepository departmentRepository;

  GetSelectableProductsUseCase({required this.departmentRepository});

  @override
  Future<Either<Failure, List<CategoryProducts>>> call(String params) {
    return departmentRepository.getSelectableProducts(country: params);
  }
}
