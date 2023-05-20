import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetFirstTimeLoggedUseCase extends UseCase<bool?, NoParams> {
  final AuthRepository authRepository;

  GetFirstTimeLoggedUseCase({required this.authRepository});
  @override
  Future<Either<Failure, bool?>> call(NoParams params) async {
    return authRepository.getIsFirstTimeLogged();
  }
}
