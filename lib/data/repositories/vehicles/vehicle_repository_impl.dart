import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/vehicles/vehicle_remote_data_source.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/vehicles/one_vehicle_response_model.dart';
import 'package:netzoon/data/models/vehicles/vehicle_model.dart';
import 'package:netzoon/data/models/vehicles/vehicle_reponse_model.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/vehicles/one_vehicle_response.dart';
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
  Future<Either<Failure, VehicleResponse>> getAllCars({
    required String country,
    required String? creator,
    required int? priceMin,
    required int? priceMax,
    required String? type,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final cars = await vehicleRemoteDataSource.getAllCars(
            country, creator, priceMin, priceMax, type);
        return Right(cars.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleResponse>> getLatestCarByCreator(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final cars =
            await vehicleRemoteDataSource.getLatestCarByCreator(country);
        return Right(cars.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleResponse>> getAllUsedPlanes(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final planes = await vehicleRemoteDataSource.getAllUsedPlanes(country);
        return Right(planes.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleResponse>> getAllNewPlanes(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final planes = await vehicleRemoteDataSource.getAllNewPlanes(country);
        return Right(planes.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getCarsCompanies(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final carsCompanies =
            await vehicleRemoteDataSource.getCarsCompanies(country);

        return Right(carsCompanies.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getPlanesCompanies(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final planesCompanies =
            await vehicleRemoteDataSource.getPlanesCompanies(country);

        return Right(planesCompanies.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getSeaCompanies(
      {required String country}) async {
    try {
      if (await networkInfo.isConnected) {
        final planesCompanies =
            await vehicleRemoteDataSource.getSeaCompanies(country);

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
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final vehicles = await vehicleRemoteDataSource.getCompanyVehicles(id);

        return Right(vehicles.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleResponse>> getAllPlanes({
    required String country,
    required String? creator,
    required int? priceMin,
    required int? priceMax,
    required String? type,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final planes = await vehicleRemoteDataSource.getAllPlanes(
            country, creator, priceMin, priceMax, type);
        return Right(planes.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addVehicle({
    required String name,
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
    File? video,
    required String country,
    String? contactNumber,
    String? exteriorColor,
    String? interiorColor,
    int? doors,
    String? bodyCondition,
    String? bodyType,
    String? mechanicalCondition,
    int? seatingCapacity,
    int? numofCylinders,
    String? transmissionType,
    String? horsepower,
    String? fuelType,
    String? extras,
    String? technicalFeatures,
    String? steeringSide,
    bool? guarantee,
    String? forWhat,
    String? regionalSpecs,
  }) async {
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
          MapEntry('country', country),
          MapEntry('contactNumber', contactNumber ?? ""),
        ]);
        if (exteriorColor != null) {
          formData.fields.add(
            MapEntry('exteriorColor', exteriorColor),
          );
        }
        if (interiorColor != null) {
          formData.fields.add(
            MapEntry('interiorColor', interiorColor),
          );
        }
        if (doors != null) {
          formData.fields.add(
            MapEntry('doors', doors.toString()),
          );
        }
        if (bodyCondition != null) {
          formData.fields.add(
            MapEntry('bodyCondition', bodyCondition),
          );
        }
        if (bodyType != null) {
          formData.fields.add(
            MapEntry('bodyType', bodyType),
          );
        }
        if (mechanicalCondition != null) {
          formData.fields.add(
            MapEntry('mechanicalCondition', mechanicalCondition),
          );
        }
        if (seatingCapacity != null) {
          formData.fields.add(
            MapEntry('seatingCapacity', seatingCapacity.toString()),
          );
        }
        if (numofCylinders != null) {
          formData.fields.add(
            MapEntry('numofCylinders', numofCylinders.toString()),
          );
        }
        if (transmissionType != null) {
          formData.fields.add(
            MapEntry('transmissionType', transmissionType),
          );
        }
        if (horsepower != null) {
          formData.fields.add(
            MapEntry('horsepower', horsepower),
          );
        }
        if (fuelType != null) {
          formData.fields.add(
            MapEntry('fuelType', fuelType),
          );
        }
        if (extras != null) {
          formData.fields.add(
            MapEntry('extras', extras),
          );
        }
        if (technicalFeatures != null) {
          formData.fields.add(
            MapEntry('technicalFeatures', technicalFeatures),
          );
        }
        if (steeringSide != null) {
          formData.fields.add(
            MapEntry('steeringSide', steeringSide),
          );
        }
        if (guarantee != null) {
          formData.fields.add(
            MapEntry('guarantee', guarantee.toString()),
          );
        }
        if (forWhat != null) {
          formData.fields.add(
            MapEntry('forWhat', forWhat),
          );
        }
        if (regionalSpecs != null) {
          formData.fields.add(
            MapEntry('regionalSpecs', regionalSpecs),
          );
        }
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
            'https://back.netzoon.com//categories/vehicle/create-vehicle',
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

  @override
  Future<Either<Failure, OneVehicleResponse>> getVehicleById(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final vehicle = await vehicleRemoteDataSource.getVehicleById(id);
        return Right(vehicle.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
