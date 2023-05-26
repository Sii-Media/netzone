part of 'get_otp_code_bloc.dart';

abstract class GetOtpCodeEvent extends Equatable {
  const GetOtpCodeEvent();

  @override
  List<Object> get props => [];
}

class GetOtpCodeRequestedEvent extends GetOtpCodeEvent {
  final String phone;

  const GetOtpCodeRequestedEvent({required this.phone});
}

class VerifyOtpCodeEvent extends GetOtpCodeEvent {
  final String phone;
  final String otp;
  final String hash;

  const VerifyOtpCodeEvent(
      {required this.phone, required this.otp, required this.hash});
}
