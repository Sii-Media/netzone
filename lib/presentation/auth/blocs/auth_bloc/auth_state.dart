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
