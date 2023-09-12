import 'package:dio/dio.dart';
import 'package:netzoon/data/models/notifications/notifications_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'notification_remote_data_source.g.dart';

abstract class NotificationRemoteDataSource {
  Future<List<MyNotificationsModel>> getAllNotifications();
  Future<MyNotificationsModel> sendNotification(
    String fcmtoken,
    String username,
    String imageUrl,
    String text,
    String category,
    String itemId,
  );

  Future<List<MyNotificationsModel>> getUnreadNotifications(String userId);

  Future<String> markAllNotificationsAsRead(String userId);
}

@RestApi(baseUrl: baseUrl)
abstract class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  factory NotificationRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _NotificationRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/notifications/get-notification')
  Future<List<MyNotificationsModel>> getAllNotifications();

  @override
  @POST('/notifications/send-notification')
  Future<MyNotificationsModel> sendNotification(
    @Part() String fcmtoken,
    @Part() String username,
    @Part() String imageUrl,
    @Part() String text,
    @Part() String category,
    @Part() String itemId,
  );

  @override
  @GET('/notifications/get-unread-notifications/{userId}')
  Future<List<MyNotificationsModel>> getUnreadNotifications(
    @Path('userId') String userId,
  );

  @override
  @PUT('/notifications/markAllNotificationsAsRead/{userId}')
  Future<String> markAllNotificationsAsRead(
    @Path('userId') String userId,
  );
}
