import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/news/news_remote_data_source.dart';
import 'package:netzoon/data/models/news/news/news_model.dart';
import 'package:netzoon/domain/news/entities/news.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/news/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSourse newsRemoteDataSourse;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.newsRemoteDataSourse,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NewsBasic>> getAllNews() async {
    try {
      if (await networkInfo.isConnected) {
        final news = await newsRemoteDataSourse.getAllNews();
        return Right(news.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
