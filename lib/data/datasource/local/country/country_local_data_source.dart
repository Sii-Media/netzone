import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';

abstract class CountryLocalDataSource {
  String? getCountry();

  Future<void> setCountry(String country);
}

class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CountryLocalDataSourceImpl({required this.sharedPreferences});
  @override
  String? getCountry() {
    if (!sharedPreferences.containsKey(SharedPreferencesKeys.userCountry)) {
      return null;
    }
    return sharedPreferences.getString(SharedPreferencesKeys.userCountry);
  }

  @override
  Future<void> setCountry(String country) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.userCountry, country);
  }
}
