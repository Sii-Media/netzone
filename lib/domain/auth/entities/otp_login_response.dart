import 'package:equatable/equatable.dart';

class OtpLoginResponse extends Equatable {
  final String message;
  final String data;

  const OtpLoginResponse({required this.message, required this.data});
  @override
  List<Object?> get props => [message, data];
}
