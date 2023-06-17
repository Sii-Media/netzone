import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicles_companies.dart';
import 'package:netzoon/domain/categories/repositories/vehicle_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetCarsCompaniesUseCase
    extends UseCase<List<VehiclesCompanies>, NoParams> {
  final VehicleRepository vehicleRepository;

  GetCarsCompaniesUseCase({required this.vehicleRepository});
  @override
  Future<Either<Failure, List<VehiclesCompanies>>> call(NoParams params) {
    return vehicleRepository.getCarsCompanies();
  }
}
