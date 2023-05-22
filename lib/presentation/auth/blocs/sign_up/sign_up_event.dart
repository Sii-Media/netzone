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
  final File? profilePhoto;
  final File? coverPhoto;
  final File? banerPhoto;

  const SignUpRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.userType,
    required this.firstMobile,
    required this.isFreeZoon,
    this.profilePhoto,
    this.coverPhoto,
    this.banerPhoto,
  });
}
