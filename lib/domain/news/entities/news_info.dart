import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/news/entities/news_comment.dart';

class News extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String imgUrl;

  final UserInfo creator;
  final List<String>? likes;
  final List<NewsComment>? comments;
  final String? createdAt;
  final String? country;

  const News({
    this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.creator,
    this.likes,
    this.comments,
    this.createdAt,
    this.country,
  });
  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imgUrl,
        creator,
        likes,
        comments,
        createdAt,
        country
      ];
}
