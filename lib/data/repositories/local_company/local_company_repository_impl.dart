import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/local_company/local_company_remote_data_source.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/company_service/company_service_model.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_model.dart';
import 'package:netzoon/data/models/local_company/local_company_model.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/company_service/company_service.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';
import 'package:share_plus/share_plus.dart';

class LocalCompanyRepositoryImpl implements LocalCompanyRepository {
  final NetworkInfo networkInfo;
  final LocalCompanyRemoteDataSource localCompanyRemoteDataSource;

  LocalCompanyRepositoryImpl(
      {required this.localCompanyRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<LocalCompany>>> getAllLocalCompany() async {
    try {
      if (await networkInfo.isConnected) {
        final localCompanies =
            await localCompanyRemoteDataSource.getAllLocalCompanies();
        return Right(localCompanies.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryProducts>>> getCompanyProducts(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final companyProducts =
            await localCompanyRemoteDataSource.getCompanyProducts(id);

        return Right(companyProducts.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getLocalCompanies({
    required String country,
    required String userType,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final companies = await localCompanyRemoteDataSource.getLocalCompanies(
            country, userType);

        return Right(
          companies.map((e) => e.toDomain()).toList(),
        );
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addCompanyService({
    required String title,
    required String description,
    int? price,
    required String owner,
    File? image,
    List<XFile>? serviceImageList,
    String? whatsAppNumber,
    String? bio,
    File? video,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();

        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('title', title),
          MapEntry('description', description),
          MapEntry('owner', owner),
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
        if (price != null) {
          formData.fields.add(
            MapEntry('price', price.toString()),
          );
        }
        if (whatsAppNumber != null) {
          formData.fields.add(
            MapEntry('whatsAppNumber', whatsAppNumber),
          );
        }
        if (bio != null) {
          formData.fields.add(
            MapEntry('bio', bio),
          );
        }

        if (serviceImageList != null && serviceImageList.isNotEmpty) {
          for (int i = 0; i < serviceImageList.length; i++) {
            String fileName = 'image$i.jpg';
            File file = File(serviceImageList[i].path);
            formData.files.add(MapEntry(
              'serviceImageList',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }
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
        Response response = await dio.post(
            'http://10.0.2.2:5000/categories/local-company/add-service',
            data: formData);

        if (response.statusCode == 201) {
          return Right(response.data);
        } else {
          return Left(ServerFailure());
        }
        // final result = await localCompanyRemoteDataSource.addCompanyService(
        //     title, description, price, owner);
        // return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CompanyService>>> getCompanyServices(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final services =
            await localCompanyRemoteDataSource.getCompanyServices(id);

        return Right(services.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> rateCompanyService(
      {required String id,
      required double rating,
      required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await localCompanyRemoteDataSource.rateCompanyService(
            id, rating, userId);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(RatingFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteCompanyService(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final result =
            await localCompanyRemoteDataSource.deleteCompanyService(id);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editCompanyService(
      {required String id,
      required String title,
      required String description,
      int? price,
      File? image,
      required List<File?> serviceImageList,
      String? whatsAppNumber}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('title', title),
          MapEntry('description', description),
        ]);
        if (price != null) {
          formData.fields.add(
            MapEntry('price', price.toString()),
          );
        }
        if (whatsAppNumber != null) {
          formData.fields.add(
            MapEntry('whatsAppNumber', whatsAppNumber),
          );
        }

        // ignore: unnecessary_null_comparison
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
        if (serviceImageList.isNotEmpty) {
          for (int i = 0; i < serviceImageList.length; i++) {
            String fileName = 'image$i.jpg';
            File? file = serviceImageList[i]; // Nullable File
            if (file != null && file.existsSync()) {
              // Check if file is not null and exists
              formData.files.add(MapEntry(
                'serviceImageList',
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType('image', 'jpeg'),
                ),
              ));
            }
          }
        }

        Response response = await dio.put(
            'http://10.0.2.2:5000/categories/local-company/$id',
            data: formData);
        // Handle the response as needed
        if (response.statusCode == 200) {
          return Right(response.data);
        } else {
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
