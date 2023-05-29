import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/factories/factories_remote_data_source.dart';
import 'package:netzoon/data/models/factories/factories_model.dart';
import 'package:netzoon/data/models/factories/factory_companies_response_model.dart';
import 'package:netzoon/domain/categories/entities/factories/factories.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/factories/factories_companies_reponse.dart';
import 'package:netzoon/domain/categories/repositories/factories_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class FactoriesRepositoryImpl implements FactoriesRepository {
  final NetworkInfo networkInfo;
  final FactoriesRemoteDataSource factoriesRemoteDataSource;

  FactoriesRepositoryImpl(
      {required this.networkInfo, required this.factoriesRemoteDataSource});
  @override
  Future<Either<Failure, List<Factories>>> getAllFactories() async {
    try {
      if (await networkInfo.isConnected) {
        final factories = await factoriesRemoteDataSource.getAllFactories();
        return Right(factories.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, FactoriesCompaniesResponse>> getFactoryCompanies(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final factoryCompanies =
            await factoriesRemoteDataSource.getFactoryCompanies(id);
        return Right(factoryCompanies.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
