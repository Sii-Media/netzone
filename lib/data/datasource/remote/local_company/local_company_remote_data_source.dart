import 'package:dio/dio.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_model.dart';
import 'package:netzoon/data/models/local_company/local_company_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';
import '../../../models/auth/user_info/user_info_model.dart';

part 'local_company_remote_data_source.g.dart';

abstract class LocalCompanyRemoteDataSource {
  Future<List<LocalCompanyModel>> getAllLocalCompanies();
  Future<List<CategoryProductsModel>> getCompanyProducts(String id);
  Future<List<UserInfoModel>> getLocalCompanies(
      String country, String userType);
}

@RestApi(baseUrl: baseUrl)
abstract class LocalCompanyRemoteDataSourceImpl
    implements LocalCompanyRemoteDataSource {
  factory LocalCompanyRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _LocalCompanyRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/categories/local-company')
  Future<List<LocalCompanyModel>> getAllLocalCompanies();

  @override
  @GET('/categories/local-company/get-products/{id}')
  Future<List<CategoryProductsModel>> getCompanyProducts(
    @Path('id') String id,
  );

  @override
  @GET('/user/getUserByType')
  Future<List<UserInfoModel>> getLocalCompanies(
    @Query('country') String country,
    @Part() String userType,
  );
}
