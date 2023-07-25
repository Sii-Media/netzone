import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:share_plus/share_plus.dart';

import '../entities/vehicles/vehicle.dart';

abstract class VehicleRepository {
  Future<Either<Failure, VehicleResponse>> getAllCars({
    required String country,
  });
  Future<Either<Failure, VehicleResponse>> getLatestCarByCreator({
    required String country,
  });
  Future<Either<Failure, VehicleResponse>> getAllUsedPlanes({
    required String country,
  });
  Future<Either<Failure, VehicleResponse>> getAllNewPlanes({
    required String country,
  });
  Future<Either<Failure, VehicleResponse>> getAllPlanes({
    required String country,
  });
  Future<Either<Failure, List<UserInfo>>> getCarsCompanies({
    required String country,
  });
  Future<Either<Failure, List<UserInfo>>> getPlanesCompanies({
    required String country,
  });
  Future<Either<Failure, List<Vehicle>>> getCompanyVehicles(
      {required String id});

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
  });
}
