import 'package:dio/dio.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/vehicles/vehicle_model.dart';
import 'package:netzoon/data/models/vehicles/vehicle_reponse_model.dart';
import 'package:netzoon/injection_container.dart';
import 'package:retrofit/http.dart';

part 'vehicle_remote_data_source.g.dart';

abstract class VehicleRemoteDataSource {
  Future<VehicleResponseModel> getAllCars(String country);
  Future<VehicleResponseModel> getLatestCarByCreator(String country);

  Future<VehicleResponseModel> getAllUsedPlanes(String country);
  Future<VehicleResponseModel> getAllNewPlanes(String country);
  Future<VehicleResponseModel> getAllPlanes(String country);

  Future<List<UserInfoModel>> getCarsCompanies(String country);
  Future<List<UserInfoModel>> getPlanesCompanies(String country);

  Future<List<VehicleModel>> getCompanyVehicles(String type, String id);
}

@RestApi(baseUrl: baseUrl)
abstract class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  factory VehicleRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _VehicleRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/categories/cars')
  Future<VehicleResponseModel> getAllCars(
    @Query('country') String country,
  );

  @override
  @GET('/categories/latest-cars-by-creator')
  Future<VehicleResponseModel> getLatestCarByCreator(
    @Query('country') String country,
  );

  @override
  @GET('/categories/planes/getoldplanes')
  Future<VehicleResponseModel> getAllUsedPlanes(
    @Query('country') String country,
  );

  @override
  @GET('/categories/planes/getnewplanes')
  Future<VehicleResponseModel> getAllNewPlanes(
    @Query('country') String country,
  );

  @override
  @GET('/categories/cars-companies')
  Future<List<UserInfoModel>> getCarsCompanies(
    @Query('country') String country,
  );

  @override
  @GET('/categories/planes-companies')
  Future<List<UserInfoModel>> getPlanesCompanies(
    @Query('country') String country,
  );

  @override
  @GET('/categories/company-vehicles')
  Future<List<VehicleModel>> getCompanyVehicles(
    @Part() String type,
    @Part() String id,
  );
  @override
  @GET('/categories/planes')
  Future<VehicleResponseModel> getAllPlanes(
    @Query('country') String country,
  );
}
