import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/favorites/repositories/favorite_repository.dart';

class AdditemToFavoriteUseCase
    extends UseCase<String, AdditemToFavoriteParams> {
  final FavoriteRepository favoriteRepository;

  AdditemToFavoriteUseCase({required this.favoriteRepository});
  @override
  Future<Either<Failure, String>> call(AdditemToFavoriteParams params) {
    return favoriteRepository.addItemToFavorite(
        userId: params.userId, productId: params.productId);
  }
}

class AdditemToFavoriteParams {
  final String userId;
  final String productId;

  AdditemToFavoriteParams({required this.userId, required this.productId});
}
