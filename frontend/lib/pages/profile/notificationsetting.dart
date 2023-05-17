import 'package:flutter/material.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';

class NotificationSetting extends StatefulWidget {
  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool _allNotificationEnabled = true;
  bool _commentNotificationEnabled = true;
  bool _chattingNotificationEnabled = true;
  bool _orderNotificationEnabled = true;

// api request
  void sendPatchRequest(bool value, String notificationType) async {
    try {
      List<String> type = [];
      if (notificationType == 'ALL') {
        type.addAll(['COMMENT', 'CHATTING', 'ORDER']);
      } else {
        if (_commentNotificationEnabled) type.add('COMMENT');
        if (_chattingNotificationEnabled) type.add('CHATTING');
        if (_orderNotificationEnabled) type.add('ORDER');
      }

      Map<String, dynamic> requestBody = {
        'type': type, // ['CHATTING', 'ORDER', 'COMMENT'] _ 리스트
        'alert': value,
      };
      Response response =
          await dioClient.dio.patch('/notices', data: requestBody);
      // Handle the response if needed
      print('PATCH request completed successfully!');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (error) {
      // Handle any errors that occur during the request
      print('Error occurred during PATCH request:');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: '알림 설정'),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(
                '전체 알림',
                style: TextStyle(fontSize: 20),
              ),
              value: _allNotificationEnabled,
              onChanged: (
                bool value,
              ) {
                setState(() {
                  _allNotificationEnabled = value;
                  _commentNotificationEnabled = value;
                  _chattingNotificationEnabled = value;
                  _orderNotificationEnabled = value;
                  sendPatchRequest(
                      value, 'ALL'); // Call the method with the new value
                });
              },
            ),
            Divider(),
            // COMMENT
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('댓글 알림'),
                value: _commentNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _commentNotificationEnabled = value;
                    _allNotificationEnabled = _commentNotificationEnabled &&
                        _chattingNotificationEnabled &&
                        _orderNotificationEnabled;
                    sendPatchRequest(
                        value, "COMMENT"); // Call the method with the new value
                    print(
                        'Comment notification enabled: $_commentNotificationEnabled');
                    print(
                        'Chatting notification enabled: $_chattingNotificationEnabled');
                    print(
                        'Order notification enabled: $_orderNotificationEnabled');
                  });
                },
              ),
            ),
            // CHATTING
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('채팅 알림'),
                value: _chattingNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _chattingNotificationEnabled = value;
                    _allNotificationEnabled = _commentNotificationEnabled &&
                        _chattingNotificationEnabled &&
                        _orderNotificationEnabled;
                    sendPatchRequest(value,
                        "CHATTING"); // Call the method with the new value
                    print(
                        'Comment notification enabled: $_commentNotificationEnabled');
                    print(
                        'Chatting notification enabled: $_chattingNotificationEnabled');
                    print(
                        'Order notification enabled: $_orderNotificationEnabled');
                  });
                },
              ),
            ),
            // ORDER
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('주문 알림'),
                value: _orderNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _orderNotificationEnabled = value;
                    _allNotificationEnabled = _commentNotificationEnabled &&
                        _chattingNotificationEnabled &&
                        _orderNotificationEnabled;
                    sendPatchRequest(
                        value, "ORDER"); // Call the method with the new value
                    print(
                        'Comment notification enabled: $_commentNotificationEnabled');
                    print(
                        'Chatting notification enabled: $_chattingNotificationEnabled');
                    print(
                        'Order notification enabled: $_orderNotificationEnabled');
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
