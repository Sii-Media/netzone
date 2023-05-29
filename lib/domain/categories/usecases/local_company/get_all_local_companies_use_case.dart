import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAllLocalCompaniesUseCase
    extends UseCase<List<LocalCompany>, NoParams> {
  final LocalCompanyRepository localCompanyRepository;

  GetAllLocalCompaniesUseCase({required this.localCompanyRepository});
  @override
  Future<Either<Failure, List<LocalCompany>>> call(NoParams params) {
    return localCompanyRepository.getAllLocalCompany();
  }
}
