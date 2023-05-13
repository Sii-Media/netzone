import 'package:dio/dio.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_response_model.dart';
import 'package:netzoon/data/models/departments/departments_categories/departments_categories_response_model.dart';
import 'package:retrofit/http.dart';

part 'departments_remote_data_source.g.dart';

abstract class DepartmentsRemoteDataSource {
  Future<DepartmentCategoryResponseModel> getCategoriesByDepartment(
    final String department,
  );
  Future<CategoryProductsResponseModel> getProductsByCategory(
    final String department,
    final String category,
  );
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class DepartmentsRemoteDataSourceImpl
    implements DepartmentsRemoteDataSource {
  factory DepartmentsRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _DepartmentsRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/departments/categories')
  Future<DepartmentCategoryResponseModel> getCategoriesByDepartment(
    @Part() String department,
  );

  @override
  @GET('/departments/products')
  Future<CategoryProductsResponseModel> getProductsByCategory(
    @Part() String department,
    @Part() String category,
  );
}
