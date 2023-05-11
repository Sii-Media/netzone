import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String imgUrl;
  final String ownerName;
  final String ownerImage;
  final String? createdAt;

  const News({
    this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.ownerName,
    required this.ownerImage,
    this.createdAt,
  });
  @override
  List<Object?> get props =>
      [title, description, imgUrl, ownerName, ownerImage, createdAt];
}
