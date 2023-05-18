import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/requests/requests_remote_data_source.dart';
import 'package:netzoon/data/models/requests/requests_response_model.dart';
import 'package:netzoon/domain/requests/entities/request_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/requests/repositories/requests_repository.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  final NetworkInfo networkInfo;
  final RequestsRemoteDataSource requestsRemoteDataSource;

  RequestsRepositoryImpl(
      {required this.networkInfo, required this.requestsRemoteDataSource});
  @override
  Future<Either<Failure, RequestResponse>> addRequest(
      {required String address, required String text}) async {
    try {
      if (await networkInfo.isConnected) {
        final request =
            await requestsRemoteDataSource.addRequest(address, text);
        return Right(request.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
