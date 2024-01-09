import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/datasource/remote/complaints/complaints_remote_data_source.dart';
import 'package:netzoon/data/models/complaints/complaints_response_model.dart';
import 'package:netzoon/domain/complaints/entities/complaints_response.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/complaints/repositories/complaints_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/injection_container.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  final NetworkInfo networkInfo;
  final ComplaintsRemoteDataSource complaintsRemoteDataSource;
  final AuthLocalDatasource local;
  final AuthRemoteDataSource authRemoteDataSource;
  ComplaintsRepositoryImpl({
    required this.networkInfo,
    required this.complaintsRemoteDataSource,
    required this.local,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, String>> addComplaints(
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
          final complaint =
              await complaintsRemoteDataSource.addComplaints(address, text);
          return Right(complaint);
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

  @override
  Future<Either<Failure, ComplaintsResponse>> getComplaints() async {
    try {
      if (await networkInfo.isConnected) {
        final complaints = await complaintsRemoteDataSource.getComplaints();
        return Right(complaints.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
