import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/favorites/entities/favorite_items.dart';
import 'package:netzoon/domain/favorites/repositories/favorite_repository.dart';

import '../../core/usecase/usecase.dart';

class GetFavoriteItemsUseCase extends UseCase<List<FavoriteItems>, String> {
  final FavoriteRepository favoriteRepository;

  GetFavoriteItemsUseCase({required this.favoriteRepository});
  @override
  Future<Either<Failure, List<FavoriteItems>>> call(String params) {
    return favoriteRepository.getFavoriteItems(userId: params);
  }
}
