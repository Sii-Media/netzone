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
      ownerName: json['ownerName'] as String,
      ownerImage: json['ownerImage'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$NewsInfoModelToJson(NewsInfoModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imgUrl': instance.imgUrl,
      'ownerName': instance.ownerName,
      'ownerImage': instance.ownerImage,
      'createdAt': instance.createdAt,
    };
