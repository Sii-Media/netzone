part of 'add_account_bloc.dart';

abstract class AddAccountEvent extends Equatable {
  const AddAccountEvent();

  @override
  List<Object> get props => [];
}

class AddAccountRequestedEvent extends AddAccountEvent {
  final String username;
  final String password;

  const AddAccountRequestedEvent(
      {required this.username, required this.password});
}

class GetUserAccountsEvent extends AddAccountEvent {}

class OnChangeAccountEvent extends AddAccountEvent {
  final String email;
  final String password;

  const OnChangeAccountEvent({required this.email, required this.password});
}
