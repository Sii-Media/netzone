import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class NewsComment extends Equatable {
  final String? id;
  final UserInfo user;
  final String? news;
  final String text;

  const NewsComment(
      {this.id, required this.user, this.news, required this.text});
  @override
  List<Object?> get props => [id, user, news, text];
}
