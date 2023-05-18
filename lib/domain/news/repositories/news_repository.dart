import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/news/entities/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, NewsBasic>> getAllNews();

  Future<Either<Failure, String>> addNews({
    required String title,
    required String description,
    required File image,
    required String ownerName,
    required String ownerImage,
    required String creator,
  });
}
