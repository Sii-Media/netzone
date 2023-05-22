import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String username,
    required String email,
    required String password,
    required String userType,
    required String firstMobile,
    required bool isFreeZoon,
    File? profilePhoto,
    File? banerPhoto,
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User?>> getSignedInUser();

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, bool>> getIsFirstTimeLogged();
  Future<Either<Failure, void>> setFirstTimeLogged(bool firstTimeLogged);
}
