import 'package:dartz/dartz.dart';
import 'package:netzoon/data/datasource/remote/fees/fees_remote_data_source.dart';
import 'package:netzoon/data/models/fees/fees_response_model.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/fees/entities/fees_resposne.dart';
import 'package:netzoon/domain/fees/repositories/fees_repository.dart';

import '../../core/utils/network/network_info.dart';

class FeesRepositoryImpl implements FeesRepository {
  final NetworkInfo networkInfo;
  final FeesRemoteDataSource feesRemoteDataSource;

  FeesRepositoryImpl(
      {required this.networkInfo, required this.feesRemoteDataSource});

  @override
  Future<Either<Failure, FeesResponse>> getFeesInfo() async {
    try {
      if (await networkInfo.isConnected) {
        final fees = await feesRemoteDataSource.getFeesInfo();
        return Right(fees.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
