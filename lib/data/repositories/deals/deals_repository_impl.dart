import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/deals/deals_remote_data_source.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_item_model.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_items_response_model.dart';
import 'package:netzoon/data/models/deals/deals_response/deals_response_model.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

class DealsRepositoryImpl implements DealsRepository {
  final DealsRemoteDataSource dealsRemoteDataSource;
  final NetworkInfo networkInfo;

  DealsRepositoryImpl(
      {required this.dealsRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, DealsResponse>> getDealsCategories() async {
    try {
      if (await networkInfo.isConnected) {
        final dealsCat = await dealsRemoteDataSource.getDealsCategories();
        return Right(dealsCat.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DealsItemsResponse>> getDealsByCategory({
    required String category,
    required String country,
    String? companyName,
    int? minPrice,
    int? maxPrice,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final dealsItem = await dealsRemoteDataSource.getDealsByCategory(
            country, category, companyName, minPrice, maxPrice);
        return Right(dealsItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(EmpltyDataFailure());
    }
  }

  @override
  Future<Either<Failure, DealsItemsResponse>> getDealsItems(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final dealItem = await dealsRemoteDataSource.getDealsItems(country);
        return Right(dealItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addDeal({
    required String name,
    required String companyName,
    required File dealImage,
    required int prevPrice,
    required int currentPrice,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    required String category,
    required String country,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();

        formData.fields.addAll([
          MapEntry('name', name),
          MapEntry('companyName', companyName),
          MapEntry('prevPrice', prevPrice.toString()),
          MapEntry('currentPrice', currentPrice.toString()),
          MapEntry('startDate', startDate.toString()),
          MapEntry('endDate', endDate.toString()),
          MapEntry('location', location),
          MapEntry('category', category),
          MapEntry('country', country),
        ]);
        // ignore: unnecessary_null_comparison
        if (dealImage != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'dealImage',
            await MultipartFile.fromFile(
              dealImage.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        Response response = await dio.post(
          'https://net-zoon.onrender.com/deals/addDeal',
          data: formData,
        );
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

  @override
  Future<Either<Failure, DealsItems>> getDealById({required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final deal = await dealsRemoteDataSource.getDealById(id);

        return Right(deal.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteDeal({required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await dealsRemoteDataSource.deleteDeal(id);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editDeal(
      {required String id,
      required String name,
      required String companyName,
      required File? dealImage,
      required int prevPrice,
      required int currentPrice,
      required DateTime startDate,
      required DateTime endDate,
      required String location,
      required String category,
      required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('id', id),
          MapEntry('name', name),
          MapEntry('companyName', companyName),
          MapEntry('prevPrice', prevPrice.toString()),
          MapEntry('currentPrice', currentPrice.toString()),
          MapEntry('startDate', startDate.toString()),
          MapEntry('endDate', endDate.toString()),
          MapEntry('location', location.toString()),
          MapEntry('category', category.toString()),
          MapEntry('country', country.toString()),
        ]);
        if (dealImage != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'dealImage',
            await MultipartFile.fromFile(
              dealImage.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        Response response = await dio.put(
          'https://net-zoon.onrender.com/deals/$id',
          data: formData,
        );
        return Right(response.data);
        // final news = await newsRemoteDataSourse.editNews(
        //     id, title, description, image, creator);
        // return Right(news.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
