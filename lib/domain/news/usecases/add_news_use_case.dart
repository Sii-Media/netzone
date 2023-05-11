import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/entities/add_news.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class AddNewsUseCase extends UseCase<AddNews, AddNewsParams> {
  final NewsRepository newsRepository;

  AddNewsUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, AddNews>> call(AddNewsParams params) {
    return newsRepository.addNews(
      title: params.title,
      description: params.description,
      imgUrl: params.imgUrl,
      ownerName: params.ownerName,
      ownerImage: params.ownerImage,
      creator: params.creator,
    );
  }
}

class AddNewsParams {
  final String title;
  final String description;
  final String imgUrl;
  final String ownerName;
  final String ownerImage;
  final String creator;

  AddNewsParams({
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.ownerName,
    required this.ownerImage,
    required this.creator,
  });
}
