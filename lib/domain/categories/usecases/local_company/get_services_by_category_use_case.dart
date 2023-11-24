import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/company_service/service_category.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetServicesByCategoryUseCase extends UseCase<ServiceCategory, String> {
  final LocalCompanyRepository localCompanyRepository;

  GetServicesByCategoryUseCase({required this.localCompanyRepository});
  @override
  Future<Either<Failure, ServiceCategory>> call(String params) {
    return localCompanyRepository.getServicesByCategories(category: params);
  }
}
