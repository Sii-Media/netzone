import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/vehicles/vehicle_remote_data_source.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/vehicles/vehicle_model.dart';
import 'package:netzoon/data/models/vehicles/vehicle_reponse_model.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';
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
  Future<Either<Failure, VehicleResponse>> getLatestCarByCreator() async {
    try {
      if (await networkInfo.isConnected) {
        final cars = await vehicleRemoteDataSource.getLatestCarByCreator();
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

  @override
  Future<Either<Failure, List<UserInfo>>> getCarsCompanies() async {
    try {
      if (await networkInfo.isConnected) {
        final carsCompanies = await vehicleRemoteDataSource.getCarsCompanies();

        return Right(carsCompanies.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getPlanesCompanies() async {
    try {
      if (await networkInfo.isConnected) {
        final planesCompanies =
            await vehicleRemoteDataSource.getPlanesCompanies();

        return Right(planesCompanies.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Vehicle>>> getCompanyVehicles(
      {required String type, required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final vehicles =
            await vehicleRemoteDataSource.getCompanyVehicles(type, id);

        return Right(vehicles.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleResponse>> getAllPlanes() async {
    try {
      if (await networkInfo.isConnected) {
        final planes = await vehicleRemoteDataSource.getAllPlanes();
        return Right(planes.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
