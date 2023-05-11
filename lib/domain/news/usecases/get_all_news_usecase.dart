import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/entities/news.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class GetAllNewsUseCase extends UseCase<NewsBasic, NoParams> {
  final NewsRepository newsRepository;

  GetAllNewsUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, NewsBasic>> call(params) {
    return newsRepository.getAllNews();
  }
}
