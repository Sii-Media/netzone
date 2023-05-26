import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/otp_login_response.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class VerifyOtpCodeUseCase
    extends UseCase<OtpLoginResponse, VerifyOtpCodeParams> {
  final AuthRepository authRepository;

  VerifyOtpCodeUseCase({required this.authRepository});
  @override
  Future<Either<Failure, OtpLoginResponse>> call(VerifyOtpCodeParams params) {
    return authRepository.verifyOtpCode(
      phone: params.phone,
      otp: params.otp,
      hash: params.hash,
    );
  }
}

class VerifyOtpCodeParams {
  final String phone;
  final String otp;
  final String hash;

  VerifyOtpCodeParams(
      {required this.phone, required this.otp, required this.hash});
}
