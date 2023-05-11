part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpInProgress extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final User user;

  const SignUpSuccess({required this.user});
}

class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure({required this.message});
}
