import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<UserInfo>>> getUsersList({
    required String userType,
  });
}
