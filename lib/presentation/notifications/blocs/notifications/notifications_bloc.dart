import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/notifications/use_cases/get_all_notifications_use_case.dart';
import 'package:netzoon/domain/notifications/use_cases/get_unread_notification_usecase.dart';
import 'package:netzoon/domain/notifications/use_cases/make_all_notification_as_read_usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/notifications/entities/notification.dart';
import '../../../../domain/notifications/use_cases/send_notification_use_case.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetAllNotificationsUseCase getAllNotificationsUseCase;
  final SendNotificationUseCase sendNotificationUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final GetUnReadNotificationUseCase getUnReadNotificationUseCase;
  NotificationsBloc({
    required this.getAllNotificationsUseCase,
    required this.sendNotificationUseCase,
    required this.getSignedInUser,
    required this.markAllNotificationsAsReadUseCase,
    required this.getUnReadNotificationUseCase,
  }) : super(NotificationsInitial()) {
    on<GetAllNotificationsEvent>((event, emit) async {
      emit(GetNotificationsInProgress());

      final notifications = await getAllNotificationsUseCase(NoParams());

      emit(
        notifications.fold(
          (failure) =>
              GetNotificationsFailure(message: mapFailureToString(failure)),
          (notifications) =>
              GetNotificationsSuccess(notifications: notifications),
        ),
      );
    });
    on<SendNotificationEvent>((event, emit) async {
      emit(SendNotificationsInProgress());

      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);
      final notification = await sendNotificationUseCase(
        SendNotificationParams(
          fcmtoken: event.fcmtoken,
          username: user?.userInfo.username ?? event.username ?? '',
          imageUrl: user?.userInfo.profilePhoto ?? '',
          text: event.text,
          category: event.category,
          itemId: event.itemId,
          body: event.body,
        ),
      );
      emit(
        notification.fold(
          (failure) =>
              SendNotificationsFailure(message: mapFailureToString(failure)),
          (myNotification) {
            return SendNotificationsSuccess(myNotification: myNotification);
          },
        ),
      );
    });
    on<GetUnreadNotificationsEvent>((event, emit) async {
      emit(GetUnreadNotificationsInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);

      final notifications =
          await getUnReadNotificationUseCase(user?.userInfo.id ?? '');
      emit(notifications.fold(
          (failure) => GetUnreadNotificationsFailure(
              message: mapFailureToString(failure)),
          (notifications) =>
              GetUnreadNotificationsSuccess(notifications: notifications)));
    });

    on<MarkAllNotificationsAsReadEvent>((event, emit) async {
      emit(MarkAllNotificationsAsReadInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User? user;
      result.fold((l) => null, (r) => user = r);

      final noti =
          await markAllNotificationsAsReadUseCase(user?.userInfo.id ?? '');
      emit(noti.fold(
          (failure) => MarkAllNotificationsAsReadFailure(
              message: mapFailureToString(failure)),
          (message) => MarkAllNotificationsAsReadSuccess(message: message)));
    });
  }
}
