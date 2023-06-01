import 'package:dio/dio.dart';
import 'package:netzoon/data/models/favorites/favorite_items_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'favorite_remote_data_source.g.dart';

abstract class FavoriteremoteDataSource {
  Future<List<FavoriteItemsModel>> getFavoriteItems(String userId);
  Future<String> addItemToFavorite(String userId, String productId);
  Future<String> removeItemFromFavorite(String userId, String productId);
  Future<String> clearFavorites(String userId);
}

@RestApi(baseUrl: baseUrl)
abstract class FavoriteremoteDataSourceImpl extends FavoriteremoteDataSource {
  factory FavoriteremoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _FavoriteremoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/user/favorites/{userId}')
  Future<List<FavoriteItemsModel>> getFavoriteItems(
    @Path('userId') String userId,
  );

  @override
  @POST('/user/favorites/add')
  Future<String> addItemToFavorite(
    @Part(name: 'userId') String userId,
    @Part(name: 'productId') String productId,
  );

  @override
  @POST('/user/favorites/remove')
  Future<String> removeItemFromFavorite(
    @Part() String userId,
    @Part() String productId,
  );

  @override
  @POST('/user/favorites/clear')
  Future<String> clearFavorites(
    @Part() String userId,
  );
}
