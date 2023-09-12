import 'package:dio/dio.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/real_estate/real_estate_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'real_estate_remote_data_source.g.dart';

abstract class RealEstateRemoteDataSource {
  Future<List<RealEstateModel>> getAllRealEstates(String country);
  Future<List<UserInfoModel>> getRealEstateCompanies(String country);
  Future<List<RealEstateModel>> getCompanyRealEstates(String id);
}

@RestApi(baseUrl: baseUrl)
abstract class RealEstateRemoteDataSourceImpl
    implements RealEstateRemoteDataSource {
  factory RealEstateRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _RealEstateRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/real-estate')
  Future<List<RealEstateModel>> getAllRealEstates(
    @Query('country') String country,
  );

  @override
  @GET('/real-estate/get-real-estate-companies')
  Future<List<UserInfoModel>> getRealEstateCompanies(
    @Query('country') String country,
  );

  @override
  @GET('/real-estate/get-companies-realestate/{id}')
  Future<List<RealEstateModel>> getCompanyRealEstates(
    @Path() String id,
  );
}
