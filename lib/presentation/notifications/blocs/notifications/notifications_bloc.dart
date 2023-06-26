import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/notifications/use_cases/get_all_notifications_use_case.dart';
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

  NotificationsBloc({
    required this.getAllNotificationsUseCase,
    required this.sendNotificationUseCase,
    required this.getSignedInUser,
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
          username: user?.userInfo.username ?? '',
          imageUrl: user?.userInfo.profilePhoto ?? '',
          text: event.text,
          category: event.category,
          itemId: event.itemId,
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
  }
}
