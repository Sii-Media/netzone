import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String description;
  final String imgUrl;
  final String date;
  final String ownerName;
  final String ownerImage;

  const News({
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.date,
    required this.ownerName,
    required this.ownerImage,
  });
  @override
  List<Object?> get props => [title, description, imgUrl, date];
}
