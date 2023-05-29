import 'package:dio/dio.dart';
import 'package:netzoon/data/models/vehicles/vehicle_reponse_model.dart';
import 'package:netzoon/injection_container.dart';
import 'package:retrofit/http.dart';

part 'vehicle_remote_data_source.g.dart';

abstract class VehicleRemoteDataSource {
  Future<VehicleResponseModel> getAllCars();
  Future<VehicleResponseModel> getAllUsedPlanes();
  Future<VehicleResponseModel> getAllNewPlanes();
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
}
