// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyNotificationsModel _$MyNotificationsModelFromJson(
        Map<String, dynamic> json) =>
    MyNotificationsModel(
      id: json['_id'] as String?,
      username: json['username'] as String,
      userProfileImage: json['userProfileImage'] as String,
      text: json['text'] as String,
      category: json['category'] as String,
      itemId: json['itemId'] as String,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$MyNotificationsModelToJson(
        MyNotificationsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'userProfileImage': instance.userProfileImage,
      'text': instance.text,
      'category': instance.category,
      'itemId': instance.itemId,
      'createdAt': instance.createdAt,
    };
