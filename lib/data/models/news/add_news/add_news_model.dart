import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/news/news_info/news_info_model.dart';
import 'package:netzoon/domain/news/entities/add_news.dart';

part 'add_news_model.g.dart';

@JsonSerializable()
class AddNewsModel {
  final String message;

  @JsonKey(name: 'result')
  final NewsInfoModel newsInfoModel;
  AddNewsModel({required this.message, required this.newsInfoModel});

  factory AddNewsModel.fromJson(Map<String, dynamic> json) =>
      _$AddNewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddNewsModelToJson(this);
}

extension MapToDomain on AddNewsModel {
  AddNews toDomain() =>
      AddNews(message: message, news: newsInfoModel.toDomain());
}
