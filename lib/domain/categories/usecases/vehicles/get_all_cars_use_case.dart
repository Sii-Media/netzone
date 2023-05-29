import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle_response.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAllCarsUseCase extends UseCase<VehicleResponse, NoParams> {
  final VehicleRepository vehicleRepository;

  GetAllCarsUseCase({required this.vehicleRepository});
  @override
  Future<Either<Failure, VehicleResponse>> call(NoParams params) {
    return vehicleRepository.getAllCars();
  }
}
