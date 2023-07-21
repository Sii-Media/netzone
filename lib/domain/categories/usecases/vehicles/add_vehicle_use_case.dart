import 'dart:io';

import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:share_plus/share_plus.dart';

class AddVehicleUseCase extends UseCase<String, AddVehicleParams> {
  final VehicleRepository vehicleRepository;

  AddVehicleUseCase({required this.vehicleRepository});
  @override
  Future<Either<Failure, String>> call(AddVehicleParams params) {
    return vehicleRepository.addVehicle(
      name: params.name,
      description: params.description,
      price: params.price,
      kilometers: params.kilometers,
      year: params.year,
      location: params.location,
      type: params.type,
      category: params.category,
      creator: params.creator,
      image: params.image,
      carimages: params.carimages,
      video: params.video,
      country: params.country,
      contactNumber: params.contactNumber,
      exteriorColor: params.exteriorColor,
      interiorColor: params.interiorColor,
      bodyCondition: params.bodyCondition,
      bodyType: params.bodyType,
      doors: params.doors,
      extras: params.extras,
      fuelType: params.fuelType,
      guarantee: params.guarantee,
      horsepower: params.horsepower,
      mechanicalCondition: params.mechanicalCondition,
      numofCylinders: params.numofCylinders,
      seatingCapacity: params.seatingCapacity,
      steeringSide: params.steeringSide,
      technicalFeatures: params.technicalFeatures,
      transmissionType: params.transmissionType,
    );
  }
}

class AddVehicleParams {
  final String name;
  final String description;
  final int price;
  final int kilometers;
  final DateTime year;
  final String location;
  final String type;
  final String category;
  final String creator;
  final File image;
  final List<XFile>? carimages;
  final File? video;
  final String country;
  final String? contactNumber;
  final String? exteriorColor;
  final String? interiorColor;
  final int? doors;
  final String? bodyCondition;
  final String? bodyType;
  final String? mechanicalCondition;
  final int? seatingCapacity;
  final int? numofCylinders;
  final String? transmissionType;
  final String? horsepower;
  final String? fuelType;
  final String? extras;
  final String? technicalFeatures;
  final String? steeringSide;
  final bool? guarantee;
  AddVehicleParams({
    required this.name,
    required this.description,
    required this.price,
    required this.kilometers,
    required this.year,
    required this.location,
    required this.type,
    required this.category,
    required this.creator,
    required this.image,
    this.carimages,
    this.video,
    required this.country,
    this.contactNumber,
    this.exteriorColor,
    this.interiorColor,
    this.doors,
    this.bodyCondition,
    this.bodyType,
    this.mechanicalCondition,
    this.seatingCapacity,
    this.numofCylinders,
    this.transmissionType,
    this.horsepower,
    this.fuelType,
    this.extras,
    this.technicalFeatures,
    this.steeringSide,
    this.guarantee,
  });
}
