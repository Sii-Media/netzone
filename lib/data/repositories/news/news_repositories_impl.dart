import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/news/news_remote_data_source.dart';
import 'package:netzoon/data/models/news/news/news_model.dart';
import 'package:netzoon/domain/news/entities/news.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSourse newsRemoteDataSourse;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.newsRemoteDataSourse,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NewsBasic>> getAllNews() async {
    try {
      if (await networkInfo.isConnected) {
        final news = await newsRemoteDataSourse.getAllNews();
        return Right(news.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addNews(
      {required String title,
      required String description,
      required File image,
      required String ownerName,
      required String ownerImage,
      required String creator}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData.fromMap({
          'title': title,
          'description': description,
          'image': await MultipartFile.fromFile(image.path,
              filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
          'ownerName': ownerName,
          'ownerImage': ownerImage,
        });

        Response response = await dio
            .post('http://10.0.2.2:5000/news/createNews', data: formData);
        // Handle the response as needed
        if (response.statusCode == 201) {
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
