import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/news/news_remote_data_source.dart';
import 'package:netzoon/data/models/news/news/news_model.dart';
import 'package:netzoon/data/models/news/news_comment/news_comment_model.dart';
import 'package:netzoon/data/models/news/news_info/news_info_model.dart';
import 'package:netzoon/domain/news/entities/news.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/news/entities/news_comment.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
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
          'creator': creator,
        });

        Response response = await dio.post(
            'https://net-zoon.onrender.com/news/createNews',
            data: formData);
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

  @override
  Future<Either<Failure, List<NewsComment>>> getComments(
      {required String newsId}) async {
    try {
      if (await networkInfo.isConnected) {
        final comments = await newsRemoteDataSourse.getComments(newsId);
        return Right(comments.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addComment(
      {required String newsId,
      required String userId,
      required String text}) async {
    try {
      if (await networkInfo.isConnected) {
        final response =
            await newsRemoteDataSourse.addComment(newsId, userId, text);
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> toggleOnLike(
      {required String newsId, required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final response =
            await newsRemoteDataSourse.toggleOnLike(newsId, userId);
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, News>> getNewsById({required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final news = await newsRemoteDataSourse.getNewsById(id);
        return Right(news.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<News>>> getCompanyNews(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final news = await newsRemoteDataSourse.getCompanyNews(id);
        return Right(news.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteNews({required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final news = await newsRemoteDataSourse.deleteNews(id);
        return Right(news);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editNews(
      {required String id,
      required String title,
      required String description,
      required File? image,
      required String creator}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('id', id),
          MapEntry('title', title),
          MapEntry('description', description),
          MapEntry('creator', creator),
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
        Response response = await dio.put(
          'https://net-zoon.onrender.com/news/$id',
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
