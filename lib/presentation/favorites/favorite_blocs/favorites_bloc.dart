// ignore_for_file: unused_local_variable

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/usecases/get_signed_in_user_use_case.dart';
import 'package:netzoon/domain/favorites/entities/favorite_items.dart';
import 'package:netzoon/domain/favorites/usecases/add_item_to_favorite_use_case.dart';
import 'package:netzoon/domain/favorites/usecases/clear_favorite_use_case.dart';
import 'package:netzoon/domain/favorites/usecases/get_favorite_items_use_case.dart';
import 'package:netzoon/domain/favorites/usecases/remove_from_favorite_use_case.dart';

import '../../../data/datasource/local/favorite/favorite_local_data_source.dart';
import '../../../domain/core/usecase/usecase.dart';
import '../../core/helpers/map_failure_to_string.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesLocalDataSource favoritesLocalDataSource;
  final GetSignedInUserUseCase getSignedInUser;
  final GetFavoriteItemsUseCase getFavoriteItemsUseCase;
  final AdditemToFavoriteUseCase additemToFavoriteUseCase;
  final RemoveItemFromFavoriteUseCase removeItemFromFavoriteUseCase;
  final ClearFavoritesUseCase clearFavoritesUseCase;
  FavoritesBloc({
    required this.favoritesLocalDataSource,
    required this.getSignedInUser,
    required this.getFavoriteItemsUseCase,
    required this.additemToFavoriteUseCase,
    required this.removeItemFromFavoriteUseCase,
    required this.clearFavoritesUseCase,
  }) : super(FavoritesInitial()) {
    on<GetFavoriteItemsEvent>((event, emit) async {
      emit(FavoriteItemsInProgress());
      final failureOrItems = await getFavoriteItemsUseCase(event.userId);

      emit(
        failureOrItems.fold(
          (failure) {
            return FavoriteItemsFailure(message: mapFailureToString(failure));
          },
          (favoriteItems) {
            return FavoriteItemsSuccess(favoriteItems: favoriteItems);
          },
        ),
      );
    });
    on<AddItemToFavoritesEvent>(
      (event, emit) async {
        final result = await getSignedInUser.call(NoParams());
        late User user;
        result.fold((l) => null, (r) => user = r!);

        final favResult = await additemToFavoriteUseCase(
            AdditemToFavoriteParams(
                userId: user.userInfo.id, productId: event.productId));

        await favoritesLocalDataSource.addToFavorites(event.productId);

        emit(const IsFavoriteState(isFavorite: true));
      },
    );
    on<RemoveItemEvent>((event, emit) async {
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);

      final favResult = await removeItemFromFavoriteUseCase(
          RemoveItemFromFavoriteParams(
              userId: user.userInfo.id, productId: event.productId));
      await favoritesLocalDataSource.removeFromFavorites(event.productId);
      emit(const IsFavoriteState(isFavorite: false));
    });
    on<RemoveItemFromFavoritesEvent>(
      (event, emit) async {
        final result = await getSignedInUser.call(NoParams());
        late User user;
        result.fold((l) => null, (r) => user = r!);

        final updatedFav = List<FavoriteItems>.from(state.props)
          ..remove(event.product);
        await favoritesLocalDataSource.removeFromFavorites(event.product.id);

        final favResult = await removeItemFromFavoriteUseCase(
            RemoveItemFromFavoriteParams(
                userId: user.userInfo.id, productId: event.product.id));
        emit(FavoriteItemsSuccess(favoriteItems: updatedFav));
      },
    );

    on<IsFavoriteEvent>((event, emit) async {
      final isFav = await isFavorite(event.productId ?? '');
      emit(IsFavoriteState(isFavorite: isFav));
    });
  }
  Future<bool> isFavorite(String productId) async {
    final favoriteList = await favoritesLocalDataSource.getFavoriteList();
    return favoriteList.contains(productId);
  }

  void checkIsFavorite(String productId) async {
    final favoriteList = await favoritesLocalDataSource.getFavoriteList();
    if (favoriteList.contains(productId)) {
      add(const IsFavoriteEvent(isFavorite: true));
    } else {
      add(const IsFavoriteEvent(isFavorite: false));
    }
  }
}
