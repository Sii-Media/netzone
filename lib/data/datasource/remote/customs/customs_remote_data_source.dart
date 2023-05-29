import 'package:dio/dio.dart';
import 'package:netzoon/data/models/customs/custom_companies_model.dart';
import 'package:netzoon/data/models/customs/customs_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'customs_remote_data_source.g.dart';

abstract class CustomsRemoteDataSource {
  Future<List<CustomModel>> getAllCustoms();
  Future<CustomsCompaniesModel> getCustomsCompanies(String id);
}

@RestApi(baseUrl: baseUrl)
abstract class CustomsRemoteDataSourceImpl implements CustomsRemoteDataSource {
  factory CustomsRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _CustomsRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/categories/get-customs-categories')
  Future<List<CustomModel>> getAllCustoms();

  @override
  @GET('/categories/customs/{id}')
  Future<CustomsCompaniesModel> getCustomsCompanies(@Path('id') String id);
}
