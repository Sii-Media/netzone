import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../../../company_service/company_service.dart';

class GetCompanyServicesUseCase extends UseCase<List<CompanyService>, String> {
  final LocalCompanyRepository localCompanyRepository;

  GetCompanyServicesUseCase({required this.localCompanyRepository});
  @override
  Future<Either<Failure, List<CompanyService>>> call(String params) {
    return localCompanyRepository.getCompanyServices(id: params);
  }
}
