import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetUserByIdUseCase extends UseCase<UserInfo, String> {
  final AuthRepository authRepository;

  GetUserByIdUseCase({required this.authRepository});
  @override
  Future<Either<Failure, UserInfo>> call(String params) {
    return authRepository.getUserById(userId: params);
  }
}
