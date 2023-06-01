import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';

class News extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String imgUrl;
  final String ownerName;
  final String ownerImage;
  final UserInfo creator;
  final String? createdAt;

  const News({
    this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.ownerName,
    required this.ownerImage,
    required this.creator,
    this.createdAt,
  });
  @override
  List<Object?> get props =>
      [title, description, imgUrl, ownerName, ownerImage, creator, createdAt];
}
