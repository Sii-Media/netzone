import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class ResetPasswordUseCase extends UseCase<String, ResetPasswordParams> {
  final AuthRepository authRepository;

  ResetPasswordUseCase({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) {
    return authRepository.resetPassword(
        password: params.password, token: params.token);
  }
}

class ResetPasswordParams {
  final String password;
  final String token;

  ResetPasswordParams({required this.password, required this.token});
}
