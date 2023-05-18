import 'package:dio/dio.dart';
import 'package:netzoon/data/models/openions/openion_response_model.dart';
import 'package:retrofit/http.dart';

part 'openion_remote_data_source.g.dart';

abstract class OpenionsRemoteDataSource {
  Future<OpenionResponseModel> addOpenion(
    final String text,
  );
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class OpenionsRemoteDataSourceImpl
    implements OpenionsRemoteDataSource {
  factory OpenionsRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _OpenionsRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @POST('/openions')
  Future<OpenionResponseModel> addOpenion(
    @Part() String text,
  );
}
