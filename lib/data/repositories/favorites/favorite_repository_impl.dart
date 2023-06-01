import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/favorites/favorite_remote_data_source.dart';
import 'package:netzoon/data/models/favorites/favorite_items_model.dart';
import 'package:netzoon/domain/favorites/entities/favorite_items.dart';

import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../domain/favorites/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final NetworkInfo networkInfo;
  final FavoriteremoteDataSource favoriteremoteDataSource;

  FavoriteRepositoryImpl(
      {required this.networkInfo, required this.favoriteremoteDataSource});

  @override
  Future<Either<Failure, List<FavoriteItems>>> getFavoriteItems(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final favorites =
            await favoriteremoteDataSource.getFavoriteItems(userId);
        return Right(favorites.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addItemToFavorite(
      {required String userId, required String productId}) async {
    try {
      if (await networkInfo.isConnected) {
        final response =
            await favoriteremoteDataSource.addItemToFavorite(userId, productId);
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> removeItemFromFavorite(
      {required String userId, required String productId}) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await favoriteremoteDataSource.removeItemFromFavorite(
            userId, productId);

        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> clearFavorites(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await favoriteremoteDataSource.clearFavorites(userId);

        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
