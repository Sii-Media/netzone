import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class ToggleFollowUseCase extends UseCase<String, ToggleFollowParams> {
  final AuthRepository authRepository;

  ToggleFollowUseCase({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(ToggleFollowParams params) {
    return authRepository.toggleFollow(
        currentUserId: params.currentUserId, otherUserId: params.otherUserId);
  }
}

class ToggleFollowParams {
  final String currentUserId;
  final String otherUserId;

  ToggleFollowParams({required this.currentUserId, required this.otherUserId});
}
