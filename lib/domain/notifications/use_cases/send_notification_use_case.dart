import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/notifications/entities/notification.dart';

import '../repositories/notification_repository.dart';

class SendNotificationUseCase
    extends UseCase<MyNotification, SendNotificationParams> {
  final NotificationRepository notificationRepository;

  SendNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, MyNotification>> call(SendNotificationParams params) {
    return notificationRepository.sendNotification(
      fcmtoken: params.fcmtoken,
      username: params.username,
      imageUrl: params.imageUrl,
      text: params.text,
      category: params.category,
      itemId: params.itemId,
      body: params.body,
    );
  }
}

class SendNotificationParams {
  final String fcmtoken;
  final String username;
  final String imageUrl;
  final String text;
  final String category;
  final String itemId;
  final String body;
  SendNotificationParams({
    required this.fcmtoken,
    required this.username,
    required this.imageUrl,
    required this.text,
    required this.category,
    required this.itemId,
    required this.body,
  });
}
