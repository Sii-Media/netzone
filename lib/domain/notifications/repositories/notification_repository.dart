import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/notifications/entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<MyNotification>>> getAllNotifications();

  Future<Either<Failure, MyNotification>> sendNotification({
    required String fcmtoken,
    required String username,
    required String imageUrl,
    required String text,
    required String category,
    required String itemId,
  });
}
