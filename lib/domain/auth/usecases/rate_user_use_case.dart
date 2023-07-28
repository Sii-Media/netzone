import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class RateUserUseCase extends UseCase<String, RateUserParams> {
  final AuthRepository authRepository;

  RateUserUseCase({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(RateUserParams params) {
    return authRepository.rateUser(
        id: params.id, rating: params.rating, userId: params.userId);
  }
}

class RateUserParams {
  final String id;
  final double rating;
  final String userId;

  RateUserParams(
      {required this.id, required this.rating, required this.userId});
}
