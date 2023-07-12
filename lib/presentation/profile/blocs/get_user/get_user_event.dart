part of 'get_user_bloc.dart';

abstract class GetUserEvent extends Equatable {
  const GetUserEvent();

  @override
  List<Object> get props => [];
}

class GetUserByIdEvent extends GetUserEvent {
  final String userId;

  const GetUserByIdEvent({required this.userId});
}

class OnEditProfileEvent extends GetUserEvent {
  final UserInfo userInfo;

  const OnEditProfileEvent({required this.userInfo});
}

class GetUserProductsEvent extends GetUserEvent {}

class GetUserProductsByIdEvent extends GetUserEvent {
  final String id;

  const GetUserProductsByIdEvent({required this.id});
}

class GetSelectedProductsEvent extends GetUserEvent {}

class GetSelectedProductsByUserIdEvent extends GetUserEvent {
  final String userId;

  const GetSelectedProductsByUserIdEvent({required this.userId});
}

class AddToSelectedProductsEvent extends GetUserEvent {
  final List<String> productIds;

  const AddToSelectedProductsEvent({required this.productIds});
}

class DeleteFromSelectedProductsEvent extends GetUserEvent {
  final String productId;

  const DeleteFromSelectedProductsEvent({required this.productId});
}

class GetUserFollowingsEvent extends GetUserEvent {}

class GetUserFollowersEvent extends GetUserEvent {}

class ToggleFollowEvent extends GetUserEvent {
  final String otherUserId;

  const ToggleFollowEvent({required this.otherUserId});
}

class IsFollowingEvent extends GetUserEvent {
  final String id;

  const IsFollowingEvent({required this.id});
}
