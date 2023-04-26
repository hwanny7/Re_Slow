import 'package:reslow/models/user.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("userId", user.userId);
    prefs.setString("accessToken", user.accessToken);
    prefs.setString("refreshToken", user.refreshToken);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString("userId")!;
    String accessToken = prefs.getString("accessToken")!;
    String refreshToken = prefs.getString("refreshToken")!;

    return User(
      userId: userId,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("userId");
    prefs.remove("accessToken");
    prefs.remove("refreshToken");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("accessToken")!;
    return accessToken;
  }
}
