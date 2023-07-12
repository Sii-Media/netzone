import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

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
import 'package:share_plus/share_plus.dart';

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

  @override
  Future<Either<Failure, String>> addVehicle(
      {required String name,
      required String description,
      required int price,
      required int kilometers,
      required DateTime year,
      required String location,
      required String type,
      required String category,
      required String creator,
      required File image,
      List<XFile>? carimages,
      File? video}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('name', name),
          MapEntry('description', description),
          MapEntry('price', price.toString()),
          MapEntry('kilometers', kilometers.toString()),
          MapEntry('year', year.toString()),
          MapEntry('location', location),
          MapEntry('type', type),
          MapEntry('category', category),
          MapEntry('creator', creator),
        ]);

        String fileName = 'image.jpg';
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ));
        if (carimages != null && carimages.isNotEmpty) {
          for (int i = 0; i < carimages.length; i++) {
            String fileName = 'image$i.jpg';
            File file = File(carimages[i].path);
            formData.files.add(MapEntry(
              'carimages',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }
        }
        if (video != null) {
          String fileName = 'video.mp4';
          formData.files.add(MapEntry(
            'video',
            await MultipartFile.fromFile(
              video.path,
              filename: fileName,
              contentType: MediaType('video', 'mp4'),
            ),
          ));
        }
        Response response = await dio.post(
            'https://net-zoon.onrender.com/categories/vehicle/create-vehicle',
            data: formData);
        if (response.statusCode == 201) {
          return Right(response.data);
        } else {
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
