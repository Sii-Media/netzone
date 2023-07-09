import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/vehicles/vehicle_response.dart';
import '../../repositories/vehicle_repository.dart';

class GetAllPlanesUseCase extends UseCase<VehicleResponse, NoParams> {
  final VehicleRepository vehicleRepository;

  GetAllPlanesUseCase({required this.vehicleRepository});

  @override
  Future<Either<Failure, VehicleResponse>> call(NoParams params) {
    return vehicleRepository.getAllPlanes();
  }
}
