part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final String username;
  final String email;
  final String password;
  final String userType;
  final String firstMobile;
  final bool isFreeZoon;

  const SignUpRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    required this.isFreeZoon,
  });
}
