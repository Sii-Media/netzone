import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class DeleteAccountUseCase extends UseCase<String, String> {
  final AuthRepository authRepository;

  DeleteAccountUseCase({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(String params) {
    return authRepository.deleteAccount(userId: params);
  }
}
