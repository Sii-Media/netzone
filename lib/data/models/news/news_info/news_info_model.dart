import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';

import '../../auth/user_info/user_info_model.dart';

part 'news_info_model.g.dart';

@JsonSerializable()
class NewsInfoModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String description;
  final String imgUrl;
  final String ownerName;
  final String ownerImage;
  final UserInfoModel creator;
  final String createdAt;

  NewsInfoModel({
    this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.ownerName,
    required this.ownerImage,
    required this.creator,
    required this.createdAt,
  });

  factory NewsInfoModel.fromJson(Map<String, dynamic> json) =>
      _$NewsInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsInfoModelToJson(this);
}

extension MapToDomain on NewsInfoModel {
  News toDomain() => News(
        title: title,
        description: description,
        imgUrl: imgUrl,
        ownerName: ownerName,
        ownerImage: ownerImage,
        creator: creator.toDomain(),
        createdAt: createdAt,
      );
}
