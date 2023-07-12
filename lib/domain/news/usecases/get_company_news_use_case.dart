import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class GetCompanyNewsUseCase extends UseCase<List<News>, String> {
  final NewsRepository newsRepository;

  GetCompanyNewsUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, List<News>>> call(String params) {
    return newsRepository.getCompanyNews(id: params);
  }
}
