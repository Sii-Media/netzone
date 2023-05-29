import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/vehicles/vehicle_remote_data_source.dart';
import 'package:netzoon/data/models/vehicles/vehicle_reponse_model.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final NetworkInfo networkInfo;
  final VehicleRemoteDataSource vehicleRemoteDataSource;

  VehicleRepositoryImpl(
      {required this.networkInfo, required this.vehicleRemoteDataSource});
  @override
  Future<Either<Failure, VehicleResponse>> getAllCars() async {
    try {
      if (await networkInfo.isConnected) {
        final cars = await vehicleRemoteDataSource.getAllCars();
        return Right(cars.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleResponse>> getAllUsedPlanes() async {
    try {
      if (await networkInfo.isConnected) {
        final planes = await vehicleRemoteDataSource.getAllUsedPlanes();
        return Right(planes.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleResponse>> getAllNewPlanes() async {
    try {
      if (await networkInfo.isConnected) {
        final planes = await vehicleRemoteDataSource.getAllNewPlanes();
        return Right(planes.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
