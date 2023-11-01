import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/tenders/tenders_remote_data_source.dart';
import 'package:netzoon/data/models/tenders/tenders_items/tendres_item_response_model.dart';
import 'package:netzoon/data/models/tenders/tenders_response/tender_response_model.dart';
import 'package:netzoon/domain/tenders/entities/tender_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tenders_items_response.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';

class TendersRepositoryImpl implements TenderRepository {
  final TendersRemoteDataSource tendersRemoteDataSource;
  final NetworkInfo networkInfo;

  TendersRepositoryImpl(
      {required this.tendersRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, TenderResponse>> getTendersCategories() async {
    try {
      if (await networkInfo.isConnected) {
        final tenderCat = await tendersRemoteDataSource.getTendersCategories();
        return Right(tenderCat.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TenderItemResponse>> getTendersItemsByMin({
    required String category,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final tenderItem =
            await tendersRemoteDataSource.getTendersItemsByMin(category);
        return Right(tenderItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TenderItemResponse>> getTendersItemsByMax(
      {required String category}) async {
    try {
      if (await networkInfo.isConnected) {
        final tenderItem =
            await tendersRemoteDataSource.getTendersItemsByMax(category);
        return Right(tenderItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TenderItemResponse>> getTendersItems() async {
    try {
      if (await networkInfo.isConnected) {
        final tenderItem = await tendersRemoteDataSource.getTendersItems();
        return Right(tenderItem.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addTender({
    required String nameAr,
    required String nameEn,
    required String companyName,
    required DateTime startDate,
    required DateTime endDate,
    required int price,
    required File tenderImage,
    required String category,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();

        formData.fields.addAll([
          MapEntry('nameAr', nameAr),
          MapEntry('nameEn', nameEn),
          MapEntry('companyName', companyName),
          MapEntry('startDate', startDate.toString()),
          MapEntry('endDate', endDate.toString()),
          MapEntry('price', price.toString()),
          MapEntry('category', category),
        ]);
        String fileName = 'image.jpg';
        formData.files.add(MapEntry(
          'tenderImage',
          await MultipartFile.fromFile(
            tenderImage.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ));
        Response response = await dio.post(
          'http://10.0.2.2:5000/tenders/add-tender',
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
}
