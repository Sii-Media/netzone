import 'dart:io';

import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class SignUpUseCase extends UseCase<User, SignUpUseCaseParams> {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(SignUpUseCaseParams params) {
    return authRepository.signUp(
      username: params.username,
      email: params.email,
      password: params.password,
      userType: params.userType,
      firstMobile: params.firstMobile,
      isFreeZoon: params.isFreeZoon,
      profilePhoto: params.profilePhoto,
      coverPhoto: params.coverPhoto,
      banerPhoto: params.banerPhoto,
    );
  }
}

class SignUpUseCaseParams {
  final String username;
  final String email;
  final String password;
  final String userType;
  final String firstMobile;
  final bool isFreeZoon;
  final File? profilePhoto;
  final File? coverPhoto;
  final File? banerPhoto;

  SignUpUseCaseParams({
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    required this.isFreeZoon,
    this.profilePhoto,
    this.coverPhoto,
    this.banerPhoto,
  });
}
