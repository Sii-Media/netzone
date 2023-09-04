import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetUnReadNotificationUseCase
    extends UseCase<List<MyNotification>, String> {
  final NotificationRepository notificationRepository;

  GetUnReadNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, List<MyNotification>>> call(String params) {
    return notificationRepository.getUnreadNotifications(userId: params);
  }
}
