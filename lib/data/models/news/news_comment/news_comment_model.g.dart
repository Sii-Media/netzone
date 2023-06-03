// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsCommentModel _$NewsCommentModelFromJson(Map<String, dynamic> json) =>
    NewsCommentModel(
      id: json['_id'] as String,
      user: UserInfoModel.fromJson(json['user'] as Map<String, dynamic>),
      news: json['news'] as String?,
      text: json['text'] as String,
    );

Map<String, dynamic> _$NewsCommentModelToJson(NewsCommentModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'news': instance.news,
      'text': instance.text,
    };
