import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/vehicles/vehicle_response.dart';
import '../../repositories/vehicle_repository.dart';

class GetAllPlanesUseCase extends UseCase<VehicleResponse, GetAllPlanesParams> {
  final VehicleRepository vehicleRepository;

  GetAllPlanesUseCase({required this.vehicleRepository});

  @override
  Future<Either<Failure, VehicleResponse>> call(GetAllPlanesParams params) {
    return vehicleRepository.getAllPlanes(
      country: params.country,
      creator: params.creator,
      priceMax: params.priceMax,
      priceMin: params.priceMin,
      type: params.type,
    );
  }
}

class GetAllPlanesParams {
  final String country;
  final String? creator;
  final int? priceMin;
  final int? priceMax;
  final String? type;

  GetAllPlanesParams(
      {required this.country,
      this.creator,
      this.priceMin,
      this.priceMax,
      this.type});
}
