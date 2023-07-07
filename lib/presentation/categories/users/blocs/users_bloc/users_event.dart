part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class GetUsersListEvent extends UsersEvent {
  final String userType;

  const GetUsersListEvent({required this.userType});
}
