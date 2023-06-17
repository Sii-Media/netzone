import 'package:dio/dio.dart';
import 'package:netzoon/data/models/vehicles/vehicle_model.dart';
import 'package:netzoon/data/models/vehicles/vehicle_reponse_model.dart';
import 'package:netzoon/injection_container.dart';
import 'package:retrofit/http.dart';

import '../../../models/vehicles/vehicles_companies_model.dart';

part 'vehicle_remote_data_source.g.dart';

abstract class VehicleRemoteDataSource {
  Future<VehicleResponseModel> getAllCars();
  Future<VehicleResponseModel> getAllUsedPlanes();
  Future<VehicleResponseModel> getAllNewPlanes();
  Future<List<VehiclesCompaniesModel>> getCarsCompanies();
  Future<List<VehiclesCompaniesModel>> getPlanesCompanies();

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
  Future<VehicleResponseModel> getAllCars();

  @override
  @GET('/categories/planes/getoldplanes')
  Future<VehicleResponseModel> getAllUsedPlanes();

  @override
  @GET('/categories/planes/getnewplanes')
  Future<VehicleResponseModel> getAllNewPlanes();

  @override
  @GET('/categories/cars-companies')
  Future<List<VehiclesCompaniesModel>> getCarsCompanies();

  @override
  @GET('/categories/planes-companies')
  Future<List<VehiclesCompaniesModel>> getPlanesCompanies();

  @override
  @GET('/categories/company-vehicles')
  Future<List<VehicleModel>> getCompanyVehicles(
    @Part() String type,
    @Part() String id,
  );
}
