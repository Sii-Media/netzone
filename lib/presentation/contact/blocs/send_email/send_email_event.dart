part of 'send_email_bloc.dart';

abstract class SendEmailEvent extends Equatable {
  const SendEmailEvent();

  @override
  List<Object> get props => [];
}

class SendEmailRequestEvent extends SendEmailEvent {
  final String name;
  final String email;
  final String subject;
  final String message;

  const SendEmailRequestEvent(
      {required this.name,
      required this.email,
      required this.subject,
      required this.message});
}
