import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/favorites/repositories/favorite_repository.dart';

import '../../core/usecase/usecase.dart';

class RemoveItemFromFavoriteUseCase
    extends UseCase<String, RemoveItemFromFavoriteParams> {
  final FavoriteRepository favoriteRepository;

  RemoveItemFromFavoriteUseCase({required this.favoriteRepository});
  @override
  Future<Either<Failure, String>> call(RemoveItemFromFavoriteParams params) {
    return favoriteRepository.removeItemFromFavorite(
        userId: params.userId, productId: params.productId);
  }
}

class RemoveItemFromFavoriteParams {
  final String userId;
  final String productId;

  RemoveItemFromFavoriteParams({required this.userId, required this.productId});
}
