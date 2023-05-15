import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/models/auth/user/user_model.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.authRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, User>> signUp(
      {required String username,
      required String email,
      required String password,
      required String userType,
      required String firstMobile,
      required bool isFreeZoon}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await authRemoteDataSource.signUp(
            username, email, password, userType, firstMobile, isFreeZoon);

        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signIn(
      {required String email, required String password}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await authRemoteDataSource.signIn(email, password);
        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }
}
