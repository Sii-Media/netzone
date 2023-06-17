import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../entities/vehicles/vehicle.dart';
import '../entities/vehicles/vehicles_companies.dart';

abstract class VehicleRepository {
  Future<Either<Failure, VehicleResponse>> getAllCars();
  Future<Either<Failure, VehicleResponse>> getAllUsedPlanes();
  Future<Either<Failure, VehicleResponse>> getAllNewPlanes();
  Future<Either<Failure, List<VehiclesCompanies>>> getCarsCompanies();
  Future<Either<Failure, List<VehiclesCompanies>>> getPlanesCompanies();
  Future<Either<Failure, List<Vehicle>>> getCompanyVehicles(
      {required String type, required String id});
}
