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
    final String country,
    final String department,
    final String category,
    final int? priceMin,
    final int? priceMax,
    final String? owner,
    final String? condition,
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

  Future<List<CategoryProductsModel>> getAllProducts(final String country);

  Future<CategoryProductsModel> getProductById(
    String productId,
  );

  Future<List<CategoryProductsModel>> getUserProducts(String userId);

  Future<String> deleteProduct(String productId);

  Future<List<CategoryProductsModel>> getSelectedProducts(String userId);

  Future<String> addToSelectedProducts(String userId, List<String> productIds);
  Future<String> deleteFromSelectedProducts(String userId, String productId);

  Future<String> rateProduct(
    final String id,
    final double rating,
    final String userId,
  );
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
    @Query('department') String department,
  );

  @override
  @GET('/departments/products')
  Future<CategoryProductsResponseModel> getProductsByCategory(
    @Query('country') String country,
    @Query('department') String department,
    @Query('category') String category,
    @Query('priceMin') int? priceMin,
    @Query('priceMax') int? priceMax,
    @Query('owner') String? owner,
    @Query('condition ') String? condition,
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
  Future<List<CategoryProductsModel>> getAllProducts(
    @Query('country') String country,
  );

  @override
  @GET('/departments/getUserProducts/{userId}')
  Future<List<CategoryProductsModel>> getUserProducts(
    @Path('userId') String userId,
  );

  @override
  @DELETE('/departments/delete-product/{productId}')
  Future<String> deleteProduct(
    @Path() String productId,
  );

  @override
  @GET('/departments/getproduct/{productId}')
  Future<CategoryProductsModel> getProductById(
    @Path() String productId,
  );

  @override
  @GET('/user/getSelectedProducts/{userId}')
  Future<List<CategoryProductsModel>> getSelectedProducts(
    @Path() String userId,
  );

  @override
  @POST('/user/addToSelectedProducts/{userId}')
  Future<String> addToSelectedProducts(
    @Path() String userId,
    @Part() List<String> productIds,
  );

  @override
  @DELETE('/user/deleteFromSelectedProducts/{userId}/{productId}')
  Future<String> deleteFromSelectedProducts(
    @Path() String userId,
    @Path() String productId,
  );

  @override
  @POST('/departments/products/{id}/rate')
  Future<String> rateProduct(
    @Path('id') String id,
    @Part() double rating,
    @Part() String userId,
  );
}
