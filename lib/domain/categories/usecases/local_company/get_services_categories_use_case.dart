import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/company_service/service_category.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetServicesCategoriesUseCase
    extends UseCase<List<ServiceCategory>, NoParams> {
  final LocalCompanyRepository localCompanyRepository;

  GetServicesCategoriesUseCase({required this.localCompanyRepository});
  @override
  Future<Either<Failure, List<ServiceCategory>>> call(NoParams params) {
    return localCompanyRepository.getServicesCategories();
  }
}
