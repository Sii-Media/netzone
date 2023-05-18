import 'package:dio/dio.dart';
import 'package:netzoon/data/models/requests/requests_response_model.dart';
import 'package:retrofit/http.dart';

part 'requests_remote_data_source.g.dart';

abstract class RequestsRemoteDataSource {
  Future<RequestsResponseModel> addRequest(
    final String address,
    final String text,
  );
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class RequestsRemoteDataSourceImpl
    implements RequestsRemoteDataSource {
  factory RequestsRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _RequestsRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @POST('/requests')
  Future<RequestsResponseModel> addRequest(
    @Part() String address,
    @Part() String text,
  );
}
