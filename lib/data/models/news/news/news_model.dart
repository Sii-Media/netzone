import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/news/news_info/news_info_model.dart';
import 'package:netzoon/domain/news/entities/news.dart';

part 'news_model.g.dart';

@JsonSerializable()
class NewsModel {
  final String message;

  @JsonKey(name: 'results')
  final List<NewsInfoModel> newsInfoModel;

  NewsModel({required this.message, required this.newsInfoModel});

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsModelToJson(this);
}

extension MapToDomain on NewsModel {
  NewsBasic toDomain() => NewsBasic(
        message: message,
        news: newsInfoModel.map((e) => e.toDomain()).toList(),
      );
}
