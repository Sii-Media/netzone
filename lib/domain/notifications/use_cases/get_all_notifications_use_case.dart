import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/notifications/entities/notification.dart';
import 'package:netzoon/domain/notifications/repositories/notification_repository.dart';

class GetAllNotificationsUseCase
    extends UseCase<List<MyNotification>, NoParams> {
  final NotificationRepository notificationRepository;

  GetAllNotificationsUseCase({required this.notificationRepository});
  @override
  Future<Either<Failure, List<MyNotification>>> call(NoParams params) {
    return notificationRepository.getAllNotifications();
  }
}
