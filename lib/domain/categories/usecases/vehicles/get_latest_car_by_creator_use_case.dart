import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/vehicles/vehicle_response.dart';
import '../../repositories/vehicle_repository.dart';

class GetLatestCarByCreatorUseCase extends UseCase<VehicleResponse, NoParams> {
  final VehicleRepository vehicleRepository;

  GetLatestCarByCreatorUseCase({required this.vehicleRepository});

  @override
  Future<Either<Failure, VehicleResponse>> call(NoParams params) {
    return vehicleRepository.getLatestCarByCreator();
  }
}
