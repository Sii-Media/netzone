import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
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
import 'package:netzoon/injection_container.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSourse newsRemoteDataSourse;
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDatasource local;
  NewsRepositoryImpl({
    required this.newsRemoteDataSourse,
    required this.networkInfo,
    required this.authRemoteDataSource,
    required this.local,
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
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
          FormData formData = FormData.fromMap({
            'title': title,
            'description': description,
            'image': await MultipartFile.fromFile(image.path,
                filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
            'ownerName': ownerName,
            'ownerImage': ownerImage,
            'creator': creator,
          });
          final user2 = local.getSignedInUser();
          Response response = await dio.post(
            'https://www.netzoonback.siidevelopment.com//news/createNews',
            data: formData,
            options:
                Options(headers: {'Authorization': 'Bearer ${user2?.token}'}),
          );
          // Handle the response as needed
          if (response.statusCode == 201) {
            return Right(response.data);
          } else {
            return Left(ServerFailure());
          }
        } else {
          return Left(CredintialFailure());
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
      print(e);
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
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            final dio = sl<Dio>();
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
          final news = await newsRemoteDataSourse.deleteNews(id);
          return Right(news);
        } else {
          return Left(CredintialFailure());
        }
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
        final user = local.getSignedInUser();
        Dio dio = Dio();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
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
          final user2 = local.getSignedInUser();
          Response response = await dio.put(
            'https://www.netzoonback.siidevelopment.com//news/$id',
            data: formData,
            options:
                Options(headers: {'Authorization': 'Bearer ${user2?.token}'}),
          );
          return Right(response.data);
        } else {
          return Left(CredintialFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
