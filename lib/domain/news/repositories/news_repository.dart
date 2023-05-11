import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/news/entities/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, NewsBasic>> getAllNews();
}
