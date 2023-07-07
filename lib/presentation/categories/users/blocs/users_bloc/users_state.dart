part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class GetUsersInProgress extends UsersState {}

class GetUsersFailure extends UsersState {
  final String message;

  const GetUsersFailure({required this.message});
}

class GetUsersSuccess extends UsersState {
  final List<UserInfo> users;

  const GetUsersSuccess({required this.users});
}
