import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/departments/departments_remote_data_source.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_response_model.dart';
import 'package:netzoon/data/models/departments/departments_categories/departments_categories_response_model.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products_response.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/departments/repositories/departments_repository.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentsRemoteDataSource departmentsRemoteDataSource;
  final NetworkInfo networkInfo;

  DepartmentRepositoryImpl(
      {required this.departmentsRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, DepartmentsCategoriesResponse>>
      getCategoriesByDepartment({required String department}) async {
    try {
      if (await networkInfo.isConnected) {
        final departmentcat = await departmentsRemoteDataSource
            .getCategoriesByDepartment(department);
        return Right(departmentcat.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CategoryProductsResponse>> getProductsByCategory(
      {required String department, required String category}) async {
    try {
      if (await networkInfo.isConnected) {
        final categoryProducts = await departmentsRemoteDataSource
            .getProductsByCategory(department, category);
        return Right(categoryProducts.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
