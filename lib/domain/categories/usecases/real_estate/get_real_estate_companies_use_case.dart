import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../repositories/real_estate_repository.dart';

class GetRealEstateCompaniesUseCase extends UseCase<List<UserInfo>, NoParams> {
  final RealEstateRepository realEstateRepository;

  GetRealEstateCompaniesUseCase({required this.realEstateRepository});

  @override
  Future<Either<Failure, List<UserInfo>>> call(NoParams params) {
    return realEstateRepository.getRealEstateCompanies();
  }
}
