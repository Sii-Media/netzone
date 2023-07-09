import 'package:dio/dio.dart';
import 'package:netzoon/data/models/real_estate/real_estate_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'real_estate_remote_data_source.g.dart';

abstract class RealEstateRemoteDataSource {
  Future<List<RealEstateModel>> getAllRealEstates();
}

@RestApi(baseUrl: baseUrl)
abstract class RealEstateRemoteDataSourceImpl
    implements RealEstateRemoteDataSource {
  factory RealEstateRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _RealEstateRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/real-estate')
  Future<List<RealEstateModel>> getAllRealEstates();
}
