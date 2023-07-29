import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class EditNewsUseCase extends UseCase<String, EditNewsParams> {
  final NewsRepository newsRepository;

  EditNewsUseCase({required this.newsRepository});
  @override
  Future<Either<Failure, String>> call(EditNewsParams params) {
    return newsRepository.editNews(
        id: params.id,
        title: params.title,
        description: params.description,
        image: params.image,
        creator: params.creator);
  }
}

class EditNewsParams {
  final String id;
  final String title;
  final String description;
  final File? image;
  final String creator;

  EditNewsParams(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.creator});
}
