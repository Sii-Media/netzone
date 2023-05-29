import 'package:dio/dio.dart';
import 'package:netzoon/data/models/govermental/govermental_companies_model.dart';
import 'package:netzoon/data/models/govermental/govermental_model.dart';

import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'govermental_data_source.g.dart';

abstract class GovermentalRemoteDataSource {
  Future<List<GovermentalModel>> getAllGovermental();
  Future<GovermentalCompaniesModel> getGovermentalCompanies(String id);
}

@RestApi(baseUrl: baseUrl)
abstract class GovermentalRemoteDataSourceImpl
    implements GovermentalRemoteDataSource {
  factory GovermentalRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _GovermentalRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/categories/govermental')
  Future<List<GovermentalModel>> getAllGovermental();

  @override
  @GET('/categories/govermental/{id}')
  Future<GovermentalCompaniesModel> getGovermentalCompanies(
    @Path('id') String id,
  );
}
