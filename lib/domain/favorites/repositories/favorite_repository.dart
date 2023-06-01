import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/favorites/entities/favorite_items.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteItems>>> getFavoriteItems({
    required String userId,
  });

  Future<Either<Failure, String>> addItemToFavorite({
    required String userId,
    required String productId,
  });

  Future<Either<Failure, String>> removeItemFromFavorite({
    required String userId,
    required String productId,
  });

  Future<Either<Failure, String>> clearFavorites({
    required String userId,
  });
}
