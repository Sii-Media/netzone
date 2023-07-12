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
  });
}
