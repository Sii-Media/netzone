import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../../auth/entities/user_info.dart';
import '../../repositories/vehicle_repository.dart';

class GetSeaCompaniesUseCase extends UseCase<List<UserInfo>, String> {
  final VehicleRepository vehicleRepository;

  GetSeaCompaniesUseCase({required this.vehicleRepository});

  @override
  Future<Either<Failure, List<UserInfo>>> call(String params) {
    return vehicleRepository.getSeaCompanies(country: params);
  }
}
