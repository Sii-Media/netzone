import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';

class NewsBasic extends Equatable {
  final String message;
  final List<News> news;

  const NewsBasic({required this.message, required this.news});
  @override
  List<Object?> get props => [message, news];
}
