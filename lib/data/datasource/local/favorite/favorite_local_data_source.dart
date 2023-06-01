import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalDataSource {
  static const String _favoriteKey = 'favorite_list';

  Future<List<String>> getFavoriteList() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList(_favoriteKey);
    return favoriteList ?? [];
  }

  Future<void> addToFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = await getFavoriteList();
    favoriteList.add(productId);
    final favoriteIds = favoriteList;
    await prefs.setStringList(_favoriteKey, favoriteIds);
  }

  Future<void> removeFromFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = await getFavoriteList();
    favoriteList.remove(productId);
    final favoriteIds = favoriteList;
    await prefs.setStringList(_favoriteKey, favoriteIds);
  }
}
