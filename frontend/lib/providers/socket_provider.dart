import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:reslow/models/chat_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:collection';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

Future<String?> _getTokenFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

class SocketManager extends ChangeNotifier {
  Map<String, dynamic> recentData = {};
  Queue<String> chatOrder = Queue();
  Map<String, int> unseenMsg = {};

  Dio dio = Dio();

  StompClient? stompClient;
  final socketUrl = "http://k8b306.p.ssafy.io:8080/ws";

  void connect() {
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));
      stompClient!.activate();
    }
  }

  void onConnect(StompFrame frame) {
    stompClient!.subscribe(
        destination: "sub/chat/room/1_test1212_test1234",
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String, dynamic> obj = json.decode(frame.body!);
            Msg message = Msg(
                roomId: "/1_test1212_test1234",
                sender: "test1212",
                receiver: "test1234",
                message: "하이 서영");
          }
        });
  }

  void sendMessage(
      String roomId, String sender, String receiver, String message) {
    print("sendMessage 시작");
    stompClient!.send(
        destination: "/pub/chat/message",
        body: json.encode({
          "roomId": roomId,
          "sender": sender,
          "receiver": receiver,
          "message": message
        }));
  }

  void disconnect() {
    print("disconnect 시작");
    if (stompClient!.isActive) {
      stompClient!.deactivate();
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
    if (stompClient!.isActive) {
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
