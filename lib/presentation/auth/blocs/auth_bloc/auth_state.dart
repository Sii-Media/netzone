part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);
}

class AuthInProgress extends AuthState {}

class Unauthenticated extends AuthState {
  final bool isFirstTimeLogged;

  const Unauthenticated(this.isFirstTimeLogged);
}

class AuthFailure extends AuthState {
  final Failure failure;

  const AuthFailure(this.failure);
}

class DeleteAccountInProgress extends AuthState {}

class DeleteAccountFailure extends AuthState {
  final String message;

  const DeleteAccountFailure({required this.message});
}

class DeleteAccountSuccess extends AuthState {}
