import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/openions/openion_remote_data_source.dart';
import 'package:netzoon/data/models/openions/openion_response_model.dart';
import 'package:netzoon/domain/openions/entities/openion_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/openions/repositories/openion_repository.dart';

class OpenionsRepositoryImpl implements OpenionsRepository {
  final NetworkInfo networkInfo;
  final OpenionsRemoteDataSource openionsRemoteDataSource;

  OpenionsRepositoryImpl(
      {required this.networkInfo, required this.openionsRemoteDataSource});
  @override
  Future<Either<Failure, OpenionResponse>> addOpenion(
      {required String text}) async {
    try {
      if (await networkInfo.isConnected) {
        final openion = await openionsRemoteDataSource.addOpenion(text);
        return Right(openion.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
