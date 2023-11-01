part of 'send_email_bloc.dart';

abstract class SendEmailState extends Equatable {
  const SendEmailState();

  @override
  List<Object> get props => [];
}

class SendEmailInitial extends SendEmailState {}

class SendEmailInProgress extends SendEmailState {}

class SendEmailSuccess extends SendEmailState {
  final String response;

  const SendEmailSuccess({required this.response});
}

class SendEmailFailure extends SendEmailState {
  final String message;

  const SendEmailFailure({required this.message});
}

class SendEmailPaymentSuccess extends SendEmailState {
  final String response;
  final double grandTotal;
  final double subtotal;
  final double serviceFee;

  const SendEmailPaymentSuccess({
    required this.response,
    required this.grandTotal,
    required this.subtotal,
    required this.serviceFee,
  });
}

class SendEmailDeliverySuccess extends SendEmailState {
  final String response;

  const SendEmailDeliverySuccess({required this.response});
}

class SendEmailPaymentAndDeliveryInProgress extends SendEmailState {}

class SendEmailPaymentAndDeliveryFailure extends SendEmailState {}

class SendEmailPaymentAndDeliverySuccess extends SendEmailState {}
