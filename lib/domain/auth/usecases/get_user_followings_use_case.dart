import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetUserFollowingsUseCase extends UseCase<List<UserInfo>, String> {
  final AuthRepository authRepository;

  GetUserFollowingsUseCase({required this.authRepository});
  @override
  Future<Either<Failure, List<UserInfo>>> call(String params) {
    return authRepository.getUserFollowings(userId: params);
  }
}
