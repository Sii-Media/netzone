import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/factories/factories.dart';
import 'package:netzoon/domain/categories/entities/factories/factories_companies_reponse.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class FactoriesRepository {
  Future<Either<Failure, List<Factories>>> getAllFactories();
  Future<Either<Failure, FactoriesCompaniesResponse>> getFactoryCompanies({
    required String id,
    required String country,
  });
}
