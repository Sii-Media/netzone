import 'package:dio/dio.dart';
import 'package:netzoon/data/models/legal_advice/legal_advice_response_model.dart';
import 'package:retrofit/http.dart';

part 'legal_advice_remote_data_source.g.dart';

abstract class LegalAdviceRemoteDataSource {
  Future<LegalAdviceResponseModel> getLegalAdvices();
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class LegalAdviceRemoteDataSourceImpl
    implements LegalAdviceRemoteDataSource {
  factory LegalAdviceRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _LegalAdviceRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/legalAdvices')
  Future<LegalAdviceResponseModel> getLegalAdvices();
}
