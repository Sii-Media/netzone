import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../repositories/local_company_reponsitory.dart';

class GetLocalCompaniesUseCase
    extends UseCase<List<UserInfo>, GetLocalCompaniesParams> {
  final LocalCompanyRepository localCompanyRepository;

  GetLocalCompaniesUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, List<UserInfo>>> call(GetLocalCompaniesParams params) {
    return localCompanyRepository.getLocalCompanies(
        country: params.country, userType: params.userType);
  }
}

class GetLocalCompaniesParams {
  final String country;
  final String userType;

  GetLocalCompaniesParams({required this.country, required this.userType});
}
