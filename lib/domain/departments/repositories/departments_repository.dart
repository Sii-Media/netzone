import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products_response.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories_response.dart';

abstract class DepartmentRepository {
  Future<Either<Failure, DepartmentsCategoriesResponse>>
      getCategoriesByDepartment({
    required String department,
  });

  Future<Either<Failure, CategoryProductsResponse>> getProductsByCategory({
    required String department,
    required String category,
  });
}
