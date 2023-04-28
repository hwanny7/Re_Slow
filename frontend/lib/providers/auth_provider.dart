import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/utils/shared_preference.dart';
// import 'package:jada/util/app_url.dart';

const String baseURL = "http://localhost:8080";

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String userId, String password) async {
    var result;
    final Map<String, dynamic> payload = {
      'data': {'userId': userId, 'password': password}
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(baseURL),
      body: json.encode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful'};
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String userId, String password, String passwordConfirmation) async {
    dynamic result;

    final Map<String, dynamic> payload = {
      'user': {
        'userId': userId,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    };
    Response response = await post(Uri.parse(baseURL),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }
}
