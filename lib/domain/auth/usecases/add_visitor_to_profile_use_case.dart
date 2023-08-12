import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class AddVisitorProfileUseCase extends UseCase<String, AddVisitorParams> {
  final AuthRepository authRepository;

  AddVisitorProfileUseCase({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(AddVisitorParams params) {
    return authRepository.addVisitor(
        userId: params.userId, viewerUserId: params.viewerUserId);
  }
}

class AddVisitorParams {
  final String userId;
  final String viewerUserId;

  AddVisitorParams({required this.userId, required this.viewerUserId});
}
