part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class GetNotificationsInProgress extends NotificationsState {}

class GetNotificationsFailure extends NotificationsState {
  final String message;

  const GetNotificationsFailure({required this.message});
}

class GetNotificationsSuccess extends NotificationsState {
  final List<MyNotification> notifications;

  const GetNotificationsSuccess({required this.notifications});
}

class SendNotificationsInProgress extends NotificationsState {}

class SendNotificationsSuccess extends NotificationsState {
  final MyNotification myNotification;

  const SendNotificationsSuccess({required this.myNotification});
}

class SendNotificationsFailure extends NotificationsState {
  final String message;

  const SendNotificationsFailure({required this.message});
}

class GetUnreadNotificationsInProgress extends NotificationsState {}

class GetUnreadNotificationsFailure extends NotificationsState {
  final String message;

  const GetUnreadNotificationsFailure({required this.message});
}

class GetUnreadNotificationsSuccess extends NotificationsState {
  final List<MyNotification> notifications;

  const GetUnreadNotificationsSuccess({required this.notifications});
}

class MarkAllNotificationsAsReadInProgress extends NotificationsState {}

class MarkAllNotificationsAsReadFailure extends NotificationsState {
  final String message;

  const MarkAllNotificationsAsReadFailure({required this.message});
}

class MarkAllNotificationsAsReadSuccess extends NotificationsState {
  final String message;

  const MarkAllNotificationsAsReadSuccess({required this.message});
}
