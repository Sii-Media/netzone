part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordRequestedEvent extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequestedEvent(
      {required this.currentPassword, required this.newPassword});
}
