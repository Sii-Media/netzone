import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/news/entities/news_info.dart';

class AddNews extends Equatable {
  final String message;
  final News news;

  const AddNews({required this.message, required this.news});

  @override
  List<Object?> get props => [message, news];
}
