import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/auth_repository.dart';

class AddAccountUseCase extends UseCase<UserInfo, AddAccountParams> {
  final AuthRepository authRepository;

  AddAccountUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserInfo>> call(AddAccountParams params) {
    return authRepository.addAcccess(
        email: params.email,
        username: params.username,
        password: params.password);
  }
}

class AddAccountParams {
  final String email;
  final String username;
  final String password;

  AddAccountParams(
      {required this.email, required this.username, required this.password});
}
