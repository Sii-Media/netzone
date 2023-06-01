import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/favorites/repositories/favorite_repository.dart';

class ClearFavoritesUseCase extends UseCase<String, String> {
  final FavoriteRepository favoriteRepository;

  ClearFavoritesUseCase({required this.favoriteRepository});
  @override
  Future<Either<Failure, String>> call(String params) {
    return favoriteRepository.clearFavorites(userId: params);
  }
}
