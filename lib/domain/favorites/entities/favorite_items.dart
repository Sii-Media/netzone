import 'package:equatable/equatable.dart';

class FavoriteItems extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final int price;
  final String category;

  const FavoriteItems({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.category,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        description,
        price,
        category,
      ];
}
