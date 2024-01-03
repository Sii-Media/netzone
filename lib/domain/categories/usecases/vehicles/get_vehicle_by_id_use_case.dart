import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/vehicles/one_vehicle_response.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetVehicleByIdUseCase extends UseCase<OneVehicleResponse, String> {
  final VehicleRepository vehicleRepository;

  GetVehicleByIdUseCase({required this.vehicleRepository});

  @override
  Future<Either<Failure, OneVehicleResponse>> call(String params) {
    return vehicleRepository.getVehicleById(id: params);
  }
}
