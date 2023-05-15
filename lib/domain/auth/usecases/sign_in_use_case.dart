
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class SignInUseCase extends UseCase<User, SignInParams> {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return authRepository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}
