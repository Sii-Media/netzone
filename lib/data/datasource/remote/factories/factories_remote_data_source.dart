import 'package:dio/dio.dart';
import 'package:netzoon/data/models/factories/factories_model.dart';
import 'package:netzoon/data/models/factories/factory_companies_response_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'factories_remote_data_source.g.dart';

abstract class FactoriesRemoteDataSource {
  Future<List<FactoriesModel>> getAllFactories();
  Future<FactoryCompaniesResponseModel> getFactoryCompanies(
      String id, String country);
}

@RestApi(baseUrl: baseUrl)
abstract class FactoriesRemoteDataSourceImpl
    implements FactoriesRemoteDataSource {
  factory FactoriesRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _FactoriesRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/categories/factories')
  Future<List<FactoriesModel>> getAllFactories();

  @override
  @GET('/categories/get-all-factories/{id}')
  Future<FactoryCompaniesResponseModel> getFactoryCompanies(
    @Path('id') String id,
    @Query('country') String country,
  );
}
