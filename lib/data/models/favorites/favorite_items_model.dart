import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/favorites/entities/favorite_items.dart';

part 'favorite_items_model.g.dart';

@JsonSerializable()
class FavoriteItemsModel {
  @JsonKey(name: 'productId')
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final int price;
  final String category;

  FavoriteItemsModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.category,
  });

  factory FavoriteItemsModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemsModelToJson(this);
}

extension MapToDomain on FavoriteItemsModel {
  FavoriteItems toDomain() => FavoriteItems(
        id: id,
        name: name,
        imageUrl: imageUrl,
        description: description,
        price: price,
        category: category,
      );
}
