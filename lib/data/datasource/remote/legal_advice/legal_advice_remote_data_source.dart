import 'package:dio/dio.dart';
import 'package:netzoon/data/models/legal_advice/legal_advice_response_model.dart';
import 'package:retrofit/http.dart';
import '../../../../injection_container.dart';

part 'legal_advice_remote_data_source.g.dart';

abstract class LegalAdviceRemoteDataSource {
  Future<LegalAdviceResponseModel> getLegalAdvices();
}

@RestApi(baseUrl: baseUrl)
abstract class LegalAdviceRemoteDataSourceImpl
    implements LegalAdviceRemoteDataSource {
  factory LegalAdviceRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _LegalAdviceRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/legalAdvices')
  Future<LegalAdviceResponseModel> getLegalAdvices();
}
