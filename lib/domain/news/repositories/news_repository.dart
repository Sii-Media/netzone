import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/news/entities/news.dart';
import 'package:netzoon/domain/news/entities/news_comment.dart';

import '../entities/news_info.dart';

abstract class NewsRepository {
  Future<Either<Failure, NewsBasic>> getAllNews();

  Future<Either<Failure, News>> getNewsById({required String id});

  Future<Either<Failure, String>> addNews({
    required String title,
    required String description,
    required File image,
    required String ownerName,
    required String ownerImage,
    required String creator,
  });

  Future<Either<Failure, News>> editNews({
    required String id,
    required String title,
    required String description,
    required File? image,
    required String creator,
  });

  Future<Either<Failure, String>> deleteNews({
    required String id,
  });

  Future<Either<Failure, List<NewsComment>>> getComments({
    required String newsId,
  });

  Future<Either<Failure, String>> addComment({
    required String newsId,
    required String userId,
    required String text,
  });
  Future<Either<Failure, String>> toggleOnLike({
    required String newsId,
    required String userId,
  });

  Future<Either<Failure, List<News>>> getCompanyNews({
    required String id,
  });
}
