import 'package:dio/dio.dart';
import 'package:netzoon/data/models/questions/question_response_model.dart';
import 'package:retrofit/http.dart';

part 'question_remote_data_source.g.dart';

abstract class QuestionRemoteDataSource {
  Future<QuestionResponseModel> addQuestion(
    final String text,
  );
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class QuestionRemoteDataSourceImpl
    implements QuestionRemoteDataSource {
  factory QuestionRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _QuestionRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @POST('/questions')
  Future<QuestionResponseModel> addQuestion(
    @Part() String text,
  );
}
