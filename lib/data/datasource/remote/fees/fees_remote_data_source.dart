import 'package:dio/dio.dart';
import 'package:netzoon/data/models/fees/fees_response_model.dart';
import 'package:netzoon/injection_container.dart';
import 'package:retrofit/http.dart';

part 'fees_remote_data_source.g.dart';

abstract class FeesRemoteDataSource {
  Future<FeesResponseModel> getFeesInfo();
}

@RestApi(baseUrl: baseUrl)
abstract class FeesRemoteDataSourceImpl implements FeesRemoteDataSource {
  factory FeesRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _FeesRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/fees')
  Future<FeesResponseModel> getFeesInfo();
}
