import 'package:dio/dio.dart';
import 'package:netzoon/data/models/news/add_news/add_news_model.dart';
import 'package:netzoon/data/models/news/news/news_model.dart';
import 'package:retrofit/http.dart';

part 'news_remote_data_source.g.dart';

abstract class NewsRemoteDataSourse {
  Future<NewsModel> getAllNews();
  Future<AddNewsModel> addNews(
    final String title,
    final String description,
    final String imgUrl,
    final String ownerName,
    final String ownerImage,
    final String creator,
  );
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class NewsRemoteDataSourseImpl implements NewsRemoteDataSourse {
  factory NewsRemoteDataSourseImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _NewsRemoteDataSourseImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/news')
  Future<NewsModel> getAllNews();

  @override
  @POST('/news/createNews')
  Future<AddNewsModel> addNews(
    @Part() String title,
    @Part() String description,
    @Part() String imgUrl,
    @Part() String ownerName,
    @Part() String ownerImage,
    @Part() String creator,
  );
}
