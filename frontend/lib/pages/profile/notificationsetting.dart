import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class NotificationSetting extends StatefulWidget {
  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool _allNotificationEnabled = true;
  bool _commentNotificationEnabled = true;
  bool _chattingNotificationEnabled = true;
  bool _orderNotificationEnabled = true;

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
              onChanged: (bool value) {
                setState(() {
                  _allNotificationEnabled = value;
                  _commentNotificationEnabled = value;
                  _chattingNotificationEnabled = value;
                  _orderNotificationEnabled = value;
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
                  });
                },
              ),
            ),
            // ORDER
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('주문서 알림'),
                value: _orderNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _orderNotificationEnabled = value;
                    _allNotificationEnabled = _commentNotificationEnabled &&
                        _chattingNotificationEnabled &&
                        _orderNotificationEnabled;
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
