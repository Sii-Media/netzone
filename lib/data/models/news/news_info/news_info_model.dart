import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';

import '../../auth/user_info/user_info_model.dart';
import '../news_comment/news_comment_model.dart';

part 'news_info_model.g.dart';

@JsonSerializable()
class NewsInfoModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String description;
  final String imgUrl;

  final UserInfoModel creator;
  final List<String> likes;
  final List<NewsCommentModel> comments;
  final String createdAt;

  NewsInfoModel({
    this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.creator,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory NewsInfoModel.fromJson(Map<String, dynamic> json) =>
      _$NewsInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsInfoModelToJson(this);
}

extension MapToDomain on NewsInfoModel {
  News toDomain() => News(
        id: id,
        title: title,
        description: description,
        imgUrl: imgUrl,
        creator: creator.toDomain(),
        likes: likes,
        comments: comments.map((e) => e.toDomain()).toList(),
        createdAt: createdAt,
      );
}
