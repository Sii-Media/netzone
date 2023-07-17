import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/factories/factories_companies_reponse.dart';
import 'package:netzoon/domain/categories/repositories/factories_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetFactoryCompaniesUseCase
    extends UseCase<FactoriesCompaniesResponse, FactoriesCompaniesParams> {
  final FactoriesRepository factoriesRepository;

  GetFactoryCompaniesUseCase({required this.factoriesRepository});
  @override
  Future<Either<Failure, FactoriesCompaniesResponse>> call(
      FactoriesCompaniesParams params) {
    return factoriesRepository.getFactoryCompanies(
        id: params.id, country: params.country);
  }
}

class FactoriesCompaniesParams {
  final String id;
  final String country;

  FactoriesCompaniesParams({required this.id, required this.country});
}
