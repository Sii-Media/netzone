import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String description;
  final String imgUrl;
  final String date;

  const News({
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.date,
  });
  @override
  List<Object?> get props => [title, description, imgUrl, date];
}
