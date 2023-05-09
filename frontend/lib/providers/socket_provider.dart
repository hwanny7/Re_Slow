import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:collection';

Future<String?> _getTokenFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

class SocketManager extends ChangeNotifier {
  Map<String, dynamic> recentData = {};
  Queue<String> chatOrder = Queue();
  Map<String, int> unseenMsg = {};

  Dio dio = Dio();

  IO.Socket socket = IO.io('http://your_socket_server_url', <String, dynamic>{
    'transports': ['websocket'],
  });

  void connect() {
    print("connect 시작");
    socket.connect();

    socket.onConnect((_) {
      print('Connected');
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    socket.on('chat_message', (data) {
      print('Received Message: $data');
      updateChat(data);
    });
  }

  void sendMessage(String message) {
    if (socket.connected) {
      socket.emit('chat_message', message);
    }
  }

  void disconnect() {
    print("disconnect 시작");
    if (socket.connected) {
      socket.disconnect();
      notifyListeners();
    }
  }

  void updateChat(data) {
    String othername = data["othername"];
    if (unseenMsg[othername] == null) {
      chatOrder.addFirst(othername);
      unseenMsg[othername] = 0;
    } else {
      chatOrder.remove(othername);
      chatOrder.addFirst(othername);
      unseenMsg[othername] = unseenMsg[othername]! + 1;
    }
    recentData[othername] = data;
    notifyListeners();
  }

  bool isConnect() {
    if (socket.connected) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> receivedChatData() async {
    print("receivedChatData 시작");
    try {
      final token = _getTokenFromSharedPreferences();
      await dio
          .get('url 넣으세요',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }))
          .then(
        (value) {
          // 데이터 recentData랑 chatOrder에 넣어
        },
      );
    } on DioError catch (e) {
      print('error: $e');
    }
  }
}
