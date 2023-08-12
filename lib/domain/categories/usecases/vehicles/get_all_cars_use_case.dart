import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAllCarsUseCase extends UseCase<VehicleResponse, GetAllCarsParams> {
  final VehicleRepository vehicleRepository;

  GetAllCarsUseCase({required this.vehicleRepository});
  @override
  Future<Either<Failure, VehicleResponse>> call(GetAllCarsParams params) {
    return vehicleRepository.getAllCars(
      country: params.country,
      creator: params.creator,
      priceMax: params.priceMax,
      priceMin: params.priceMin,
      type: params.type,
    );
  }
}

class GetAllCarsParams {
  final String country;
  final String? creator;
  final int? priceMin;
  final int? priceMax;
  final String? type;

  GetAllCarsParams(
      {required this.country,
      this.creator,
      this.priceMin,
      this.priceMax,
      this.type});
}
