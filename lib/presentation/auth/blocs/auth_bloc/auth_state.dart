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
  final Failure failure;
  const DeleteAccountFailure({
    required this.message,
    required this.failure,
  });
}

class DeleteAccountSuccess extends AuthState {}

class SigninWithFacebookInProgress extends AuthState {}

class SigninWithFacebookFailure extends AuthState {}

class SigninWithFacebookSuccess extends AuthState {
  final Map<String, dynamic> userData;

  const SigninWithFacebookSuccess({required this.userData});
}

class OAuthSignInProgress extends AuthState {}

class OAuthSignFailure extends AuthState {}

class OAuthSignSuccess extends AuthState {
  final User user;

  const OAuthSignSuccess({required this.user});
}

class SigninWithGoogleInProgress extends AuthState {}

class SigninWithGoogleFailure extends AuthState {}

class SigninWithGoogleSuccess extends AuthState {
  final String email;
  final String username;
  final String profile;

  const SigninWithGoogleSuccess(
      {required this.email, required this.username, required this.profile});
}

class ForgetPasswordInProgress extends AuthState {}

class ForgetPasswordFailure extends AuthState {}

class ForgetPasswordSuccess extends AuthState {
  final String result;

  const ForgetPasswordSuccess({required this.result});
}

class ResetPasswordInProgress extends AuthState {}

class ResetPasswordFailure extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final String result;

  const ResetPasswordSuccess({required this.result});
}
