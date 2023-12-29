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

class SigninWithFacebookEvent extends AuthEvent {}

class SigninWithGoogleEvent extends AuthEvent {}

class OAuthSignEvent extends AuthEvent {
  final String email;
  final String username;
  final String profilePhoto;
  const OAuthSignEvent({
    required this.email,
    required this.username,
    required this.profilePhoto,
  });
}

class ForgetPasswordEvent extends AuthEvent {
  final String email;

  const ForgetPasswordEvent({required this.email});
}

class ResetPasswordEvent extends AuthEvent {
  final String password;
  final String token;

  const ResetPasswordEvent({required this.password, required this.token});
}
