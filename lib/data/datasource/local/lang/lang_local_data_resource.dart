import 'package:netzoon/data/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LangLocalDataResource {
  Future<String> setLang(String eventlang);
  Future<String> getInit();
}

class LangLocalDataResourceImpl implements LangLocalDataResource {
  final SharedPreferences sharedPreferences;

  LangLocalDataResourceImpl({required this.sharedPreferences});
  @override
  Future<String> getInit() async {
    var ln =
        sharedPreferences.getString(SharedPreferencesKeys.language) ?? 'ar';
    return ln;
  }

  @override
  Future<String> setLang(String eventlang) async {
    sharedPreferences.setString(SharedPreferencesKeys.language, eventlang);
    return eventlang;
  }
}
