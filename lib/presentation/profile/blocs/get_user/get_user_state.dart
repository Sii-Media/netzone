part of 'get_user_bloc.dart';

abstract class GetUserState extends Equatable {
  const GetUserState();

  @override
  List<UserInfo> get props => [];
}

class GetUserInitial extends GetUserState {}

class GetUserInProgress extends GetUserState {}

class GetUserSuccess extends GetUserState {
  final UserInfo userInfo;

  const GetUserSuccess({required this.userInfo});
  @override
  List<UserInfo> get props => [userInfo];
}

class GetUserFailure extends GetUserState {
  final String message;

  const GetUserFailure({required this.message});
}

class OnEditSuccess extends GetUserState {
  final UserInfo userInfo;

  const OnEditSuccess(this.userInfo);
  @override
  List<UserInfo> get props => [userInfo];
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

class GetSelectedProductsInProgress extends GetUserState {}

class GetSelectedProductsFailure extends GetUserState {
  final String message;

  const GetSelectedProductsFailure({required this.message});
}

class GetSelectedProductsSuccess extends GetUserState {
  final List<CategoryProducts> products;

  const GetSelectedProductsSuccess({required this.products});
}

class AddToSelectedProductsInProgress extends GetUserState {}

class AddToSelectedProductsFailure extends GetUserState {
  final String message;

  const AddToSelectedProductsFailure({required this.message});
}

class AddToSelectedProductsSuccess extends GetUserState {
  final String message;

  const AddToSelectedProductsSuccess({required this.message});
}

class DeleteFromSelectedProductsInProgress extends GetUserState {}

class DeleteFromSelectedProductsFailure extends GetUserState {
  final String message;

  const DeleteFromSelectedProductsFailure({required this.message});
}

class DeleteFromSelectedProductsSuccess extends GetUserState {
  final String message;

  const DeleteFromSelectedProductsSuccess({required this.message});
}

class ProductRemovedState extends GetUserState {
  final List<CategoryProducts> updatedProducts;

  const ProductRemovedState(this.updatedProducts);
}
