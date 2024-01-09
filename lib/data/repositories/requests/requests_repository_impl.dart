import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/datasource/remote/requests/requests_remote_data_source.dart';
import 'package:netzoon/data/models/requests/requests_response_model.dart';
import 'package:netzoon/domain/requests/entities/request_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/requests/repositories/requests_repository.dart';
import 'package:netzoon/injection_container.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  final NetworkInfo networkInfo;
  final RequestsRemoteDataSource requestsRemoteDataSource;
  final AuthLocalDatasource local;
  final AuthRemoteDataSource authRemoteDataSource;
  RequestsRepositoryImpl({
    required this.networkInfo,
    required this.requestsRemoteDataSource,
    required this.local,
    required this.authRemoteDataSource,
  });
  @override
  Future<Either<Failure, RequestResponse>> addRequest(
      {required String address, required String text}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = local.getSignedInUser();
        if (user != null) {
          if (JwtDecoder.isExpired(user.token)) {
            try {
              if (JwtDecoder.isExpired(user.refreshToken)) {
                local.logout();
                return Left(UnAuthorizedFailure());
              }
            } catch (e) {
              return Left(UnAuthorizedFailure());
            }
            final refreshTokenResponse =
                await authRemoteDataSource.refreshToken(user.refreshToken);
            final newUser = user.copyWith(
                refreshTokenResponse.refreshToken, user.refreshToken);
            await local.signInUser(newUser);
            final dio = sl<Dio>();
            dio.options.headers['Authorization'] = 'Bearer ${newUser.token}';
          }
          final request =
              await requestsRemoteDataSource.addRequest(address, text);
          return Right(request.toDomain());
        } else {
          return Left(CredintialFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
