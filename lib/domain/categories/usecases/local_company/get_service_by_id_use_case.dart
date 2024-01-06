import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/company_service/company_service.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetServiceByIdUseCase extends UseCase<CompanyService, String> {
  final LocalCompanyRepository localCompanyRepository;

  GetServiceByIdUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, CompanyService>> call(String params) {
    return localCompanyRepository.getServiceById(id: params);
  }
}
