import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class VehicleRepository {
  Future<Either<Failure, VehicleResponse>> getAllCars();
  Future<Either<Failure, VehicleResponse>> getAllUsedPlanes();
  Future<Either<Failure, VehicleResponse>> getAllNewPlanes();
}
