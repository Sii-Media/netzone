import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class LogoutUseCase extends UseCase<Unit, NoParams> {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});
  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.logout();
  }
}
