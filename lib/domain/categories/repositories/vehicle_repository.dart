import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../entities/vehicles/vehicle.dart';

abstract class VehicleRepository {
  Future<Either<Failure, VehicleResponse>> getAllCars();
  Future<Either<Failure, VehicleResponse>> getLatestCarByCreator();
  Future<Either<Failure, VehicleResponse>> getAllUsedPlanes();
  Future<Either<Failure, VehicleResponse>> getAllNewPlanes();
  Future<Either<Failure, VehicleResponse>> getAllPlanes();
  Future<Either<Failure, List<UserInfo>>> getCarsCompanies();
  Future<Either<Failure, List<UserInfo>>> getPlanesCompanies();
  Future<Either<Failure, List<Vehicle>>> getCompanyVehicles(
      {required String type, required String id});
}
