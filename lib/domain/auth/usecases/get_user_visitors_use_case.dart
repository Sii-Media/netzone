import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetUserVisitorsUseCase extends UseCase<List<UserInfo>, String> {
  final AuthRepository authRepository;

  GetUserVisitorsUseCase({required this.authRepository});
  @override
  Future<Either<Failure, List<UserInfo>>> call(String params) {
    return authRepository.getVisitors(id: params);
  }
}
