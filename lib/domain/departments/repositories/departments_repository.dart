import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
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

  Future<Either<Failure, String>> addProduct({
    required String departmentName,
    required String categoryName,
    required String name,
    required String description,
    required int price,
    List<String>? images,
    String? videoUrl,
    String? guarantee,
    String? property,
    String? madeIn,
    required File image,
  });

  Future<Either<Failure, List<CategoryProducts>>> getAllProducts();

  Future<Either<Failure, CategoryProducts>> getProductById({
    required String productId,
  });

  Future<Either<Failure, List<CategoryProducts>>> getUserProducts({
    required String userId,
  });

  Future<Either<Failure, String>> deleteProduct({
    required String productId,
  });

  Future<Either<Failure, String>> editProduct({
    required String productId,
    required String name,
    required String description,
    required File? image,
    File? video,
    required int price,
    bool? guarantee,
    String? address,
    String? madeIn,
  });

  Future<Either<Failure, List<CategoryProducts>>> getSelectedProducts({
    required String userId,
  });

  Future<Either<Failure, String>> addToSelectedProducts({
    required String userId,
    required List<String> productIds,
  });

  Future<Either<Failure, String>> deleteFromSelectedProducts({
    required String userId,
    required String productId,
  });
}
