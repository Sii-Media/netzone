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
