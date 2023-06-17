import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../entities/vehicles/vehicle.dart';

class GetCompanyVehiclesUseCase
    extends UseCase<List<Vehicle>, GetCompanyVehiclesParams> {
  final VehicleRepository vehicleRepository;

  GetCompanyVehiclesUseCase({required this.vehicleRepository});
  @override
  Future<Either<Failure, List<Vehicle>>> call(GetCompanyVehiclesParams params) {
    return vehicleRepository.getCompanyVehicles(
        type: params.type, id: params.id);
  }
}

class GetCompanyVehiclesParams {
  final String type;
  final String id;

  GetCompanyVehiclesParams({required this.type, required this.id});
}
