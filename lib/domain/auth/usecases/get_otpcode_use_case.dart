import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/otp_login_response.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetOtpCodeUseCase extends UseCase<OtpLoginResponse, GetOtpCodeParams> {
  final AuthRepository authRepository;

  GetOtpCodeUseCase({required this.authRepository});
  @override
  Future<Either<Failure, OtpLoginResponse>> call(GetOtpCodeParams params) {
    return authRepository.getOtpCode(mobileNumber: params.mobileNumber);
  }
}

class GetOtpCodeParams {
  final String mobileNumber;

  GetOtpCodeParams({required this.mobileNumber});
}
