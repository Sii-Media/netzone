// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsInfoModel _$NewsInfoModelFromJson(Map<String, dynamic> json) =>
    NewsInfoModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      imgUrl: json['imgUrl'] as String,
      creator: UserInfoModel.fromJson(json['creator'] as Map<String, dynamic>),
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => NewsCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$NewsInfoModelToJson(NewsInfoModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
      'creator': instance.creator,
      'likes': instance.likes,
      'comments': instance.comments,
      'createdAt': instance.createdAt,
    };
