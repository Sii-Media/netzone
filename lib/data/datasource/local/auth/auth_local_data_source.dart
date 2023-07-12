import 'dart:convert';

import 'package:netzoon/data/core/constants/constants.dart';
import 'package:netzoon/data/models/auth/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<void> signInUser(UserModel user);

  UserModel? getSignedInUser();

  void logout();

  void setFirstTimeLogged(bool firstTimeLogged);

  bool getIsFirstTimeLogged();
  Future<void> toggoleFollow(String id);
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;

  AuthLocalDatasourceImpl({required this.sharedPreferences});
  @override
  UserModel? getSignedInUser() {
    if (!sharedPreferences.containsKey(SharedPreferencesKeys.user)) return null;

    return UserModel.fromJson(
      json.decode(sharedPreferences.getString(SharedPreferencesKeys.user)!)
          as Map<String, dynamic>,
    );
  }

  @override
  void logout() {
    sharedPreferences.remove(SharedPreferencesKeys.user);
  }

  @override
  Future<void> signInUser(UserModel user) async {
    await sharedPreferences.setString(
      SharedPreferencesKeys.user,
      json.encode(user.toJson()),
    );
  }

  @override
  bool getIsFirstTimeLogged() {
    return sharedPreferences.getBool(SharedPreferencesKeys.isFirstTimeLogged) !=
        false;
  }

  @override
  void setFirstTimeLogged(bool firstTimeLogged) {
    sharedPreferences.setBool(
        SharedPreferencesKeys.isFirstTimeLogged, firstTimeLogged);
  }

  @override
  Future<void> toggoleFollow(String id) async {
    final user = getSignedInUser();
    final isFollow = user?.userInfo.followings?.contains(id);
    if (isFollow == true) {
      user?.userInfo.followings?.remove(id);
    } else {
      user?.userInfo.followings?.add(id);
    }
    await sharedPreferences.setString(
      SharedPreferencesKeys.user,
      json.encode(user?.toJson()),
    );
  }
}
