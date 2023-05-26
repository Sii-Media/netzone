part of 'get_otp_code_bloc.dart';

abstract class GetOtpCodeState extends Equatable {
  const GetOtpCodeState();

  @override
  List<Object> get props => [];
}

class GetOtpCodeInitial extends GetOtpCodeState {}

class GetOtpCodeInProgress extends GetOtpCodeState {}

class GetOtpCodeSuccess extends GetOtpCodeState {
  final OtpLoginResponse response;
  const GetOtpCodeSuccess({required this.response});
}

class GetOtpCodeFailure extends GetOtpCodeState {
  final String message;

  const GetOtpCodeFailure(this.message);
}
