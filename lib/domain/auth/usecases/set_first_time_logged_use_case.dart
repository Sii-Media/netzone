import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class SetFirstTimeLoggedUseCase
    extends UseCase<void, SetFirstTimeLoggedUseCaseParams> {
  final AuthRepository authRepository;

  SetFirstTimeLoggedUseCase({required this.authRepository});
  @override
  Future<Either<Failure, void>> call(SetFirstTimeLoggedUseCaseParams params) {
    return authRepository.setFirstTimeLogged(params.isFirstTimeLogged);
  }
}

class SetFirstTimeLoggedUseCaseParams {
  final bool isFirstTimeLogged;

  SetFirstTimeLoggedUseCaseParams({required this.isFirstTimeLogged});
}
