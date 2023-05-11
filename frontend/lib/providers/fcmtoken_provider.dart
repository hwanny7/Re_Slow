import 'package:flutter/foundation.dart';

class FCMTokenProvider with ChangeNotifier {
  String fcmToken = "";

  void setFCMToken(String? newToken) {
    fcmToken = newToken!;
    notifyListeners();
  }
}
