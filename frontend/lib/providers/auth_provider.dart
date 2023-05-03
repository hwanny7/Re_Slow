import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/utils/shared_preference.dart';

String baseURL = "http://k8b306.p.ssafy.io:8080/members";

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
    dynamic result;
    final Map<String, dynamic> payload = {'id': userId, 'password': password};

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse('$baseURL/login'),
      body: json.encode(payload),
      headers: {'Content-Type': 'application/json'},
    );
    Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      User authUser = User.fromJson(responseData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'user': responseData};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

      result = {'status': false, 'message': responseData['error']};
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String id, String password, String nickname) async {
    dynamic result;

    final Map<String, dynamic> payload = {
      'id': id.toLowerCase(),
      'password': password,
      'nickname': nickname,
    };

    // lowercase로 바꾸기!!!
    _registeredInStatus = Status.Registering;
    notifyListeners();

    Response response = await post(Uri.parse('$baseURL/'),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      result = {'status': true, 'message': 'Successful'};
      _registeredInStatus = Status.Registered;
      notifyListeners();
    } else {
      result = {'status': false, 'message': responseData['message']};
      _registeredInStatus = Status.NotRegistered;
    }
    return result;
  }

  Future<bool> checkId(String id) async {
    final Map<String, dynamic> payload = {
      'id': id,
    };

    Response response = await post(Uri.parse('$baseURL/id'),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    print('kkkkkkkkkk');
    print(responseData);
    if (responseData['isPossible'] == "YES") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkNickname(String nickname) async {
    final Map<String, dynamic> payload = {
      'nickname': nickname,
    };

    Response response = await post(Uri.parse('$baseURL/nickname'),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['isPossible'] == "YES") {
      return true;
    } else {
      return false;
    }
  }
}
