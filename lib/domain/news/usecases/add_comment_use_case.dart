import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class AddCommentUseCase extends UseCase<String, AddCommentParams> {
  final NewsRepository newsRepository;

  AddCommentUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, String>> call(AddCommentParams params) {
    return newsRepository.addComment(
        newsId: params.newsId, userId: params.userId, text: params.text);
  }
}

class AddCommentParams {
  final String newsId;
  final String userId;
  final String text;

  AddCommentParams(
      {required this.newsId, required this.userId, required this.text});
}
