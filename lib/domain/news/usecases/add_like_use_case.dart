import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

import '../../core/usecase/usecase.dart';

class ToggleOnLikeUseCase extends UseCase<String, ToggleOnLikeParams> {
  final NewsRepository newsRepository;

  ToggleOnLikeUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, String>> call(ToggleOnLikeParams params) {
    return newsRepository.toggleOnLike(
        newsId: params.newsId, userId: params.userId);
  }
}

class ToggleOnLikeParams {
  final String newsId;
  final String userId;

  ToggleOnLikeParams({required this.newsId, required this.userId});
}
