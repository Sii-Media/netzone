// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddNewsModel _$AddNewsModelFromJson(Map<String, dynamic> json) => AddNewsModel(
      message: json['message'] as String,
      newsInfoModel:
          NewsInfoModel.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddNewsModelToJson(AddNewsModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'result': instance.newsInfoModel,
    };
