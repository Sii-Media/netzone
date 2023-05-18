import 'package:dartz/dartz.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/legal_advice/legal_advice_remote_data_source.dart';
import 'package:netzoon/data/models/legal_advice/legal_advice_response_model.dart';
import 'package:netzoon/domain/legal_advice/entities/legal_advice_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/legal_advice/repositories/legal_advice_repository.dart';

class LegalAdviceRepositoryImpl implements LegalAdviceRepository {
  final NetworkInfo networkInfo;
  final LegalAdviceRemoteDataSource legalAdviceRemoteDataSource;

  LegalAdviceRepositoryImpl(
      {required this.networkInfo, required this.legalAdviceRemoteDataSource});

  @override
  Future<Either<Failure, LegalAdviceResponse>> getLegalAdvices() async {
    try {
      if (await networkInfo.isConnected) {
        final legalAdvice = await legalAdviceRemoteDataSource.getLegalAdvices();
        return Right(legalAdvice.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
