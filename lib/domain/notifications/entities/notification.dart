import 'package:equatable/equatable.dart';

class MyNotification extends Equatable {
  final String? id;
  final String username;
  final String userProfileImage;
  final String text;
  final String? createdAt;
  final String category;
  final String itemId;

  const MyNotification({
    this.id,
    required this.username,
    required this.userProfileImage,
    required this.text,
    this.createdAt,
    required this.category,
    required this.itemId,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        userProfileImage,
        text,
        createdAt,
        category,
        itemId,
      ];
}
