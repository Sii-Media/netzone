import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase extends UseCase<String, String> {
  final NotificationRepository notificationRepository;

  MarkAllNotificationsAsReadUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, String>> call(String params) {
    return notificationRepository.markAllNotificationsAsRead(userId: params);
  }
}
