import 'package:dio/dio.dart';
import 'package:netzoon/data/models/freezone/freezone_company/freezone_company_response_model.dart';
import 'package:netzoon/data/models/freezone/freezone_places/freezone_response_model.dart';
import 'package:netzoon/injection_container.dart';
import 'package:retrofit/http.dart';

part 'freezone_remote_data_source.g.dart';

abstract class FreeZoneRemoteDataSource {
  Future<FreeZoneResponseModel> getFreeZonePlaces();
  Future<FreeZoneCompanyResponseModel> getFreeZonePlacesById(String id);
}

@RestApi(baseUrl: baseUrl)
abstract class FreeZoneRemoteDataSourceImpl
    implements FreeZoneRemoteDataSource {
  factory FreeZoneRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _FreeZoneRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/categories/freezoon')
  Future<FreeZoneResponseModel> getFreeZonePlaces();

  @override
  @GET('/categories/freezoon/{id}')
  Future<FreeZoneCompanyResponseModel> getFreeZonePlacesById(
    @Path('id') String id,
  );
}
