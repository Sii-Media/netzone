import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/auth_repository.dart';

class ChangePasswordUseCase extends UseCase<String, ChangePasswordParams> {
  final AuthRepository authRepository;

  ChangePasswordUseCase({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(ChangePasswordParams params) {
    return authRepository.changePassword(
        userId: params.userId,
        currentPassword: params.currentPassword,
        newPassword: params.newPassword);
  }
}

class ChangePasswordParams {
  final String userId;
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams(
      {required this.userId,
      required this.currentPassword,
      required this.newPassword});
}
