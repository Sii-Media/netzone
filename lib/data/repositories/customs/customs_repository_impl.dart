import 'package:netzoon/data/datasource/remote/customs/customs_remote_data_source.dart';
import 'package:netzoon/data/models/customs/custom_companies_model.dart';
import 'package:netzoon/data/models/customs/customs_model.dart';
import 'package:netzoon/domain/categories/entities/customs/customs_company.dart';
import 'package:netzoon/domain/categories/entities/customs/customs.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/customs_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../core/utils/network/network_info.dart';

class CustomsRepositoryImpl implements CustomsRepository {
  final NetworkInfo networkInfo;
  final CustomsRemoteDataSource customsRemoteDataSource;

  CustomsRepositoryImpl({
    required this.customsRemoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Customs>>> getAllCustoms() async {
    try {
      if (await networkInfo.isConnected) {
        final customs = await customsRemoteDataSource.getAllCustoms();
        return Right(customs.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CustomsCompanies>> getCustomCompanies(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final customCompanies =
            await customsRemoteDataSource.getCustomsCompanies(id);
        return Right(customCompanies.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
