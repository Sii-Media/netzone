part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordInProgress extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String result;

  const ChangePasswordSuccess({required this.result});
}

class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  final Failure failure;
  const ChangePasswordFailure({
    required this.message,
    required this.failure,
  });
}
