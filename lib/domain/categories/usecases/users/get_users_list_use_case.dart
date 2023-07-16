import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../../core/usecase/usecase.dart';
import '../../repositories/users_repository.dart';

class GetUsersListUseCase extends UseCase<List<UserInfo>, GetUsersListParams> {
  final UsersRepository usersRepository;

  GetUsersListUseCase({required this.usersRepository});
  @override
  Future<Either<Failure, List<UserInfo>>> call(GetUsersListParams params) {
    return usersRepository.getUsersList(
        country: params.country, userType: params.userType);
  }
}

class GetUsersListParams {
  final String country;
  final String userType;

  GetUsersListParams({required this.country, required this.userType});
}
