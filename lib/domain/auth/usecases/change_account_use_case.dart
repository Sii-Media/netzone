import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class ChangeAccountUseCase extends UseCase<User, ChangeAccountParams> {
  final AuthRepository authRepository;

  ChangeAccountUseCase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(ChangeAccountParams params) {
    return authRepository.changeAccount(
      email: params.email,
      password: params.password,
    );
  }
}

class ChangeAccountParams {
  final String email;
  final String password;

  ChangeAccountParams({
    required this.email,
    required this.password,
  });
}
