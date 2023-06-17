import 'dart:io';

import 'package:dio/dio.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_response_model.dart';
import 'package:netzoon/data/models/departments/departments_categories/departments_categories_response_model.dart';
import 'package:retrofit/http.dart';
import '../../../../injection_container.dart';
import '../../../models/departments/category_products/category_products_model.dart';

part 'departments_remote_data_source.g.dart';

abstract class DepartmentsRemoteDataSource {
  Future<DepartmentCategoryResponseModel> getCategoriesByDepartment(
    final String department,
  );
  Future<CategoryProductsResponseModel> getProductsByCategory(
    final String department,
    final String category,
  );

  Future<String> addProduct(
    final String departmentName,
    final String categoryName,
    final String name,
    final String description,
    final int price,
    final List<String>? images,
    final String? videoUrl,
    final String? guarantee,
    final String? property,
    final String? madeIn,
    final File image,
  );

  Future<List<CategoryProductsModel>> getAllProducts();
  Future<List<CategoryProductsModel>> getUserProducts(String username);
}

@RestApi(baseUrl: baseUrl)
abstract class DepartmentsRemoteDataSourceImpl
    implements DepartmentsRemoteDataSource {
  factory DepartmentsRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      // contentType: 'application/json',
      // headers: {'Content-Type': 'application/json'},
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

  @override
  @POST('/departments/addProduct')
  @MultiPart()
  Future<String> addProduct(
      @Part() String departmentName,
      @Part() String categoryName,
      @Part() String name,
      @Part() String description,
      @Part() int price,
      @Part() List<String>? images,
      @Part() String? videoUrl,
      @Part() String? guarantee,
      @Part() String? property,
      @Part() String? madeIn,
      @Part(name: "image") File image);

  @override
  @GET('/departments/allProducts')
  Future<List<CategoryProductsModel>> getAllProducts();

  @override
  @GET('/departments/getUserProducts')
  Future<List<CategoryProductsModel>> getUserProducts(
    @Part() String username,
  );
}
