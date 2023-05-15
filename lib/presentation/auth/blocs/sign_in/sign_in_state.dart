part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInInProgress extends SignInState {}

class SignInSuccess extends SignInState {
  final User user;

  const SignInSuccess({required this.user});
}

class SignInFailure extends SignInState {
  final String message;

  const SignInFailure({required this.message});
}
