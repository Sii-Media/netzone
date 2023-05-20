import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetSignedInUserUseCase extends UseCase<User?, NoParams> {
  final AuthRepository authRepository;

  GetSignedInUserUseCase({required this.authRepository});
  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return authRepository.getSignedInUser();
  }
}
