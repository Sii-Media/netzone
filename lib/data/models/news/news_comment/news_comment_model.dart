import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/news/entities/news_comment.dart';

part 'news_comment_model.g.dart';

@JsonSerializable()
class NewsCommentModel {
  @JsonKey(name: '_id')
  final String id;
  final UserInfoModel user;
  final String? news;
  final String text;

  NewsCommentModel(
      {required this.id, required this.user, this.news, required this.text});

  factory NewsCommentModel.fromJson(Map<String, dynamic> json) =>
      _$NewsCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsCommentModelToJson(this);
}

extension MapToDomain on NewsCommentModel {
  NewsComment toDomain() => NewsComment(
        id: id,
        user: user.toDomain(),
        news: news,
        text: text,
      );
}
