part of 'add_account_bloc.dart';

abstract class AddAccountState extends Equatable {
  const AddAccountState();

  @override
  List<Object> get props => [];
}

class AddAccountInitial extends AddAccountState {}

class AddAccountInProgress extends AddAccountState {}

class AddAccountSuccess extends AddAccountState {
  final UserInfo userInfo;

  const AddAccountSuccess({required this.userInfo});
}

class AddAccountFailure extends AddAccountState {
  final String message;
  final Failure failure;
  const AddAccountFailure({
    required this.message,
    required this.failure,
  });
}

class GetUserAccountsInProgress extends AddAccountState {}

class GetUserAccountsFailure extends AddAccountState {
  final String message;

  const GetUserAccountsFailure({required this.message});
}

class GetUserAccountsSuccess extends AddAccountState {
  final List<UserInfo> users;

  const GetUserAccountsSuccess({required this.users});
}

class OnChangeAccountInProgress extends AddAccountState {}

class OnChangeAccountFailure extends AddAccountState {
  final String message;

  const OnChangeAccountFailure({required this.message});
}

class OnChangeAccountSuccess extends AddAccountState {
  final User user;

  const OnChangeAccountSuccess({required this.user});
}
