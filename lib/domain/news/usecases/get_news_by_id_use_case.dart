import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../entities/news_info.dart';
import '../repositories/news_repository.dart';

class GetNewsByIdUseCase extends UseCase<News, String> {
  final NewsRepository newsRepository;

  GetNewsByIdUseCase({required this.newsRepository});

  @override
  Future<Either<Failure, News>> call(String params) {
    return newsRepository.getNewsById(id: params);
  }
}
