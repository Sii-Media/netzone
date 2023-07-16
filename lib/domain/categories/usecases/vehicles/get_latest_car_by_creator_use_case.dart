import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/vehicles/vehicle_response.dart';
import '../../repositories/vehicle_repository.dart';

class GetLatestCarByCreatorUseCase extends UseCase<VehicleResponse, String> {
  final VehicleRepository vehicleRepository;

  GetLatestCarByCreatorUseCase({required this.vehicleRepository});

  @override
  Future<Either<Failure, VehicleResponse>> call(String params) {
    return vehicleRepository.getLatestCarByCreator(country: params);
  }
}
