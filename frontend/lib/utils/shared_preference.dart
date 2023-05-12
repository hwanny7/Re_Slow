import 'package:flutter/material.dart';
import 'package:reslow/models/user.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<SharedPreferences> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("accessToken", user.accessToken!);
    prefs.setString("refreshToken", user.refreshToken!);
    prefs.setBool("existAccount", user.existAccount!);

    return prefs;
  }

  Future<bool> getExistAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? existAccount = prefs.getBool("existAccount")!;
    return existAccount;
  }

  Future<void> setTrueAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("existAccount", true);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // String userId = prefs.getString("userId")!;
    String accessToken = prefs.getString("accessToken")!;
    String refreshToken = prefs.getString("refreshToken")!;

    return User(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<bool> removeUser(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("accessToken");
      prefs.remove("refreshToken");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    return accessToken != null && accessToken.isNotEmpty;
  }
}
