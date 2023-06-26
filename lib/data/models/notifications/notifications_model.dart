import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/notifications/entities/notification.dart';

part 'notifications_model.g.dart';

@JsonSerializable()
class MyNotificationsModel {
  @JsonKey(name: '_id')
  final String? id;
  final String username;
  final String userProfileImage;
  final String text;
  final String category;
  final String itemId;
  final String? createdAt;

  MyNotificationsModel({
    this.id,
    required this.username,
    required this.userProfileImage,
    required this.text,
    required this.category,
    required this.itemId,
    this.createdAt,
  });

  factory MyNotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$MyNotificationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyNotificationsModelToJson(this);
}

extension MapToDomain on MyNotificationsModel {
  MyNotification toDomain() => MyNotification(
        id: id,
        username: username,
        userProfileImage: userProfileImage,
        text: text,
        createdAt: createdAt,
        category: category,
        itemId: itemId,
      );
}
