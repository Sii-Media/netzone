import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/models/auth/user/user_model.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDatasource local;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.authRemoteDataSource,
      required this.local,
      required this.networkInfo});
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
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.setBool('IsLoggedIn', true);
        local.signInUser(user);

        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signIn(
      {required String email, required String password}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await authRemoteDataSource.signIn(email, password);
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.setBool('IsLoggedIn', true);
        local.signInUser(user);
        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getSignedInUser() async {
    return right(local.getSignedInUser()?.toDomain());
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    local.logout();
    return right(unit);
  }

  @override
  Future<Either<Failure, bool>> getIsFirstTimeLogged() async {
    return right(local.getIsFirstTimeLogged());
  }

  @override
  Future<Either<Failure, void>> setFirstTimeLogged(bool firstTimeLogged) async {
    return right(local.setFirstTimeLogged(firstTimeLogged));
  }
}
