import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

import '../entities/news_comment.dart';

class GetCommentsUseCase extends UseCase<List<NewsComment>, String> {
  final NewsRepository newsRepository;

  GetCommentsUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, List<NewsComment>>> call(String params) {
    return newsRepository.getComments(newsId: params);
  }
}
