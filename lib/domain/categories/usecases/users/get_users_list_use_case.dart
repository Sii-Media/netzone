import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../../core/usecase/usecase.dart';
import '../../repositories/users_repository.dart';

class GetUsersListUseCase extends UseCase<List<UserInfo>, String> {
  final UsersRepository usersRepository;

  GetUsersListUseCase({required this.usersRepository});
  @override
  Future<Either<Failure, List<UserInfo>>> call(String params) {
    return usersRepository.getUsersList(userType: params);
  }
}
