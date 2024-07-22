import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';
import 'dart:io';

class AddNewsUseCase extends UseCase<String, AddNewsParams> {
  final NewsRepository newsRepository;

  AddNewsUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, String>> call(AddNewsParams params) {
    return newsRepository.addNews(
      title: params.title,
      description: params.description,
      image: params.image,
      ownerName: params.ownerName,
      ownerImage: params.ownerImage,
      creator: params.creator,
      country: params.country,
    );
  }
}

class AddNewsParams {
  final String title;
  final String description;
  final File image;
  final String ownerName;
  final String ownerImage;
  final String creator;
  final String country;

  AddNewsParams({
    required this.title,
    required this.description,
    required this.image,
    required this.ownerName,
    required this.ownerImage,
    required this.creator,
    required this.country,
  });
}
