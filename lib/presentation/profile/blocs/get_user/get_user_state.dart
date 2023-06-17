part of 'get_user_bloc.dart';

abstract class GetUserState extends Equatable {
  const GetUserState();

  @override
  List<Object> get props => [];
}

class GetUserInitial extends GetUserState {}

class GetUserInProgress extends GetUserState {}

class GetUserSuccess extends GetUserState {
  final UserInfo userInfo;

  const GetUserSuccess({required this.userInfo});
  @override
  List<Object> get props => [userInfo];
}

class GetUserFailure extends GetUserState {
  final String message;

  const GetUserFailure({required this.message});
}

class OnEditSuccess extends GetUserState {
  final UserInfo userInfo;

  const OnEditSuccess(this.userInfo);
  @override
  List<Object> get props => [userInfo];
}

class GetUserProductsSuccess extends GetUserState {
  final List<CategoryProducts> products;

  const GetUserProductsSuccess({required this.products});
}

class GetUserProductsInProgress extends GetUserState {}

class GetUserProductsFailure extends GetUserState {
  final String message;

  const GetUserProductsFailure({required this.message});
}
