part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLogin extends AuthEvent {
  final User user;

  const AuthLogin(this.user);
}

class AuthLogout extends AuthEvent {}

class AuthSetFirstTimeLogged extends AuthEvent {
  final bool isFirstTimeLogged;
  const AuthSetFirstTimeLogged({required this.isFirstTimeLogged});
}

class DeleteMyAccountEvent extends AuthEvent {}
