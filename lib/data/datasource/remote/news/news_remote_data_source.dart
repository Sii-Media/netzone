import 'package:dio/dio.dart';
import 'package:netzoon/data/models/news/news/news_model.dart';
import 'package:retrofit/http.dart';

part 'news_remote_data_source.g.dart';

abstract class NewsRemoteDataSourse {
  Future<NewsModel> getAllNews();
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
}
