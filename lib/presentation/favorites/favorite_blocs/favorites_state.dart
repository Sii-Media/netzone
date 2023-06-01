part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoriteItemsInProgress extends FavoritesState {}

class FavoriteItemsSuccess extends FavoritesState {
  final List<FavoriteItems> favoriteItems;

  const FavoriteItemsSuccess({required this.favoriteItems});

  @override
  List<Object> get props => favoriteItems;
}

class FavoriteItemsFailure extends FavoritesState {
  final String message;

  const FavoriteItemsFailure({required this.message});
}

class FavoritesAdded extends FavoritesState {}

class FavoritesRemoved extends FavoritesState {}

class IsFavoriteState extends FavoritesState {
  final bool isFavorite;

  const IsFavoriteState({required this.isFavorite});
  @override
  List<Object> get props => [isFavorite];
}
