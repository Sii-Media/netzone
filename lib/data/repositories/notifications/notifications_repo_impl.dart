import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/notifications/notification_remote_data_source.dart';
import 'package:netzoon/data/models/notifications/notifications_model.dart';
import 'package:netzoon/domain/notifications/entities/notification.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/notifications/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;
  final NetworkInfo networkInfo;
  NotificationRepositoryImpl(
      {required this.notificationRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<MyNotification>>> getAllNotifications() async {
    try {
      if (await networkInfo.isConnected) {
        final notifications =
            await notificationRemoteDataSource.getAllNotifications();

        return Right(notifications.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MyNotification>> sendNotification({
    required String fcmtoken,
    required String username,
    required String imageUrl,
    required String text,
    required String category,
    required String itemId,
    required String body,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final notification =
            await notificationRemoteDataSource.sendNotification(
          fcmtoken,
          username,
          imageUrl,
          text,
          category,
          itemId,
          body,
        );
        return Right(notification.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MyNotification>>> getUnreadNotifications(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final unReadNotifications =
            await notificationRemoteDataSource.getUnreadNotifications(userId);
        return Right(unReadNotifications.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> markAllNotificationsAsRead(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final notification = await notificationRemoteDataSource
            .markAllNotificationsAsRead(userId);
        return Right(notification);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
