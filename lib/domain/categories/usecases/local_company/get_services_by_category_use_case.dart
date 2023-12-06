import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/company_service/service_category.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetServicesByCategoryUseCase
    extends UseCase<ServiceCategory, GetServicesByCategoryParams> {
  final LocalCompanyRepository localCompanyRepository;

  GetServicesByCategoryUseCase({required this.localCompanyRepository});
  @override
  Future<Either<Failure, ServiceCategory>> call(
      GetServicesByCategoryParams params) {
    return localCompanyRepository.getServicesByCategories(
        category: params.category, country: params.country);
  }
}

class GetServicesByCategoryParams {
  final String category;
  final String country;

  GetServicesByCategoryParams({required this.category, required this.country});
}
