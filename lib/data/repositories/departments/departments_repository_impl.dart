import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/departments/departments_remote_data_source.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_model.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_response_model.dart';
import 'package:netzoon/data/models/departments/departments_categories/departments_categories_response_model.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
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
  Future<Either<Failure, CategoryProductsResponse>> getProductsByCategory({
    required String department,
    required String category,
    required String country,
    int? priceMin,
    int? priceMax,
    String? owner,
    String? condition,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final categoryProducts =
            await departmentsRemoteDataSource.getProductsByCategory(country,
                department, category, priceMin, priceMax, owner, condition);
        return Right(categoryProducts.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(EmpltyDataFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addProduct(
      {required String departmentName,
      required String categoryName,
      required String name,
      required String description,
      required int price,
      required double weight,
      List<String>? images,
      String? videoUrl,
      String? guarantee,
      String? property,
      String? madeIn,
      required String country,
      required File image}) async {
    try {
      if (await networkInfo.isConnected) {
// Create MultipartFile from File

        // final product = await departmentsRemoteDataSource.addProduct(
        //   departmentName,
        //   categoryName,
        //   name,
        //   description,
        //   price,
        //   images,
        //   videoUrl,
        //   guarantee,
        //   property,
        //   madeIn,
        //   image,
        // );
        return const Right('success');
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryProducts>>> getAllProducts({
    required String country,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final products =
            await departmentsRemoteDataSource.getAllProducts(country);
        return Right(products.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryProducts>>> getSelectableProducts(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final products =
            await departmentsRemoteDataSource.getSelectableProducts(country);
        return Right(products.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryProducts>>> getUserProducts(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final products =
            await departmentsRemoteDataSource.getUserProducts(userId);
        return Right(products.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteProduct(
      {required String productId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result =
            await departmentsRemoteDataSource.deleteProduct(productId);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editProduct(
      {required String productId,
      required String name,
      required String description,
      required File? image,
      File? video,
      required int price,
      bool? guarantee,
      String? address,
      String? madeIn}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();

        formData.fields.addAll([
          MapEntry('name', name),
          MapEntry('description', description),
          MapEntry('price', price.toString()),
          MapEntry('guarantee', guarantee.toString()),
          MapEntry('madeIn', madeIn ?? ''),
          MapEntry('address', address ?? ''),
        ]);

        if (image != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        if (video != null) {
          String fileName = 'video.mp4';
          formData.files.add(MapEntry(
            'video',
            await MultipartFile.fromFile(
              video.path,
              filename: fileName,
              contentType: MediaType('video', 'mp4'),
            ),
          ));
        }
        Response response = await dio.put(
          'http://145.14.158.175:5000/departments/editProduct/$productId',
          data: formData,
        );
        return Right(response.data);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CategoryProducts>> getProductById(
      {required String productId}) async {
    try {
      if (await networkInfo.isConnected) {
        final product =
            await departmentsRemoteDataSource.getProductById(productId);

        return Right(product.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryProducts>>> getSelectedProducts(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final products =
            await departmentsRemoteDataSource.getSelectedProducts(userId);
        return Right(products.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addToSelectedProducts(
      {required String userId, required List<String> productIds}) async {
    try {
      if (await networkInfo.isConnected) {
        final products = await departmentsRemoteDataSource
            .addToSelectedProducts(userId, productIds);
        return Right(products);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteFromSelectedProducts(
      {required String userId, required String productId}) async {
    try {
      if (await networkInfo.isConnected) {
        final products = await departmentsRemoteDataSource
            .deleteFromSelectedProducts(userId, productId);
        return Right(products);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> rateProduct(
      {required String id,
      required double rating,
      required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final rate =
            await departmentsRemoteDataSource.rateProduct(id, rating, userId);
        return Right(rate);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(RatingFailure());
    }
  }
}
