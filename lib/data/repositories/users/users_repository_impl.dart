import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/users/users_remote_data_source.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import 'package:netzoon/domain/auth/entities/user_info.dart';

import 'package:dartz/dartz.dart';

import '../../../domain/categories/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final NetworkInfo networkInfo;
  final UsersRemoteDataSource userRemoteDataSource;

  UsersRepositoryImpl(
      {required this.networkInfo, required this.userRemoteDataSource});
  @override
  Future<Either<Failure, List<UserInfo>>> getUsersList({
    required String country,
    required String userType,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final users =
            await userRemoteDataSource.getUsersList(country, userType);

        return Right(users.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
