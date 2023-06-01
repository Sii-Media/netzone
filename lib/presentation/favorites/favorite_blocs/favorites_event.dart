part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetFavoriteItemsEvent extends FavoritesEvent {
  final String userId;

  const GetFavoriteItemsEvent({required this.userId});
}

class AddItemToFavoritesEvent extends FavoritesEvent {
  final String productId;

  const AddItemToFavoritesEvent({required this.productId});

  @override
  List<Object> get props => [];
}

class RemoveItemFromFavoritesEvent extends FavoritesEvent {
  final FavoriteItems product;

  const RemoveItemFromFavoritesEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class ClearFavoritesEvent extends FavoritesEvent {
  final String userId;

  const ClearFavoritesEvent({required this.userId});
}

class RemoveItemEvent extends FavoritesEvent {
  final String productId;

  const RemoveItemEvent({required this.productId});
}

class IsFavoriteEvent extends FavoritesEvent {
  final String? productId;
  final bool? isFavorite;

  const IsFavoriteEvent({
    this.productId,
    this.isFavorite,
  });
}
