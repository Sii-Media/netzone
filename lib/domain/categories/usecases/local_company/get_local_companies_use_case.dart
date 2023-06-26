import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../repositories/local_company_reponsitory.dart';

class GetLocalCompaniesUseCase extends UseCase<List<UserInfo>, String> {
  final LocalCompanyRepository localCompanyRepository;

  GetLocalCompaniesUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, List<UserInfo>>> call(String params) {
    return localCompanyRepository.getLocalCompanies(userType: params);
  }
}
