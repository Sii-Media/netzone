import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products_response.dart';
import 'package:netzoon/domain/departments/repositories/departments_repository.dart';

class GetCategoryProductsUseCase
    extends UseCase<CategoryProductsResponse, CategoryProductsParams> {
  final DepartmentRepository departmentRepository;

  GetCategoryProductsUseCase({required this.departmentRepository});

  @override
  Future<Either<Failure, CategoryProductsResponse>> call(
      CategoryProductsParams params) {
    return departmentRepository.getProductsByCategory(
        department: params.department,
        category: params.category,
        country: params.country);
  }
}

class CategoryProductsParams {
  final String department;
  final String category;
  final String country;

  CategoryProductsParams({
    required this.department,
    required this.category,
    required this.country,
  });
}
