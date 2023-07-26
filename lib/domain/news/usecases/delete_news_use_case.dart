import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class DeleteNewsUseCase extends UseCase<String, String> {
  final NewsRepository newsRepository;

  DeleteNewsUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, String>> call(String params) {
    return newsRepository.deleteNews(id: params);
  }
}
