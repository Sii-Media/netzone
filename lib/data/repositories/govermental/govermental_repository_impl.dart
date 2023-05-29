import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/govermental/govermental_data_source.dart';
import 'package:netzoon/data/models/govermental/govermental_companies_model.dart';
import 'package:netzoon/data/models/govermental/govermental_model.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_companies.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/govermental_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class GovermentalRepositoryImpl extends GovermentalRepository {
  final NetworkInfo networkInfo;
  final GovermentalRemoteDataSource govermentalRemoteDataSource;

  GovermentalRepositoryImpl(
      {required this.networkInfo, required this.govermentalRemoteDataSource});
  @override
  Future<Either<Failure, List<Govermental>>> getAllGovermental() async {
    try {
      if (await networkInfo.isConnected) {
        final govermental =
            await govermentalRemoteDataSource.getAllGovermental();
        return Right(govermental.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GovermentalCompanies>> getGovermentalCompanies(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final companies =
            await govermentalRemoteDataSource.getGovermentalCompanies(id);
        return Right(companies.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
