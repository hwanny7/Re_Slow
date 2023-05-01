import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class NotificationSetting extends StatefulWidget {
  @override
  _NotificationSettingState createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool _allNotificationEnabled = true;
  bool _likeNotificationEnabled = true;
  bool _commentNotificationEnabled = true;
  bool _chatNotificationEnabled = true;
  bool _eventNotificationEnabled = true;
  bool _moneyNotificationEnabled = true;

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
                  _likeNotificationEnabled = value;
                  _commentNotificationEnabled = value;
                  _chatNotificationEnabled = value;
                  _eventNotificationEnabled = value;
                  _moneyNotificationEnabled = value;
                });
              },
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('관심 알림'),
                value: _likeNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _likeNotificationEnabled = value;
                    _allNotificationEnabled = _likeNotificationEnabled &&
                        _commentNotificationEnabled &&
                        _chatNotificationEnabled &&
                        _eventNotificationEnabled &&
                        _moneyNotificationEnabled;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('댓글 알림'),
                value: _commentNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _commentNotificationEnabled = value;
                    _allNotificationEnabled = _likeNotificationEnabled &&
                        _commentNotificationEnabled &&
                        _chatNotificationEnabled &&
                        _eventNotificationEnabled &&
                        _moneyNotificationEnabled;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('채팅 알림'),
                value: _chatNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _chatNotificationEnabled = value;
                    _allNotificationEnabled = _likeNotificationEnabled &&
                        _commentNotificationEnabled &&
                        _chatNotificationEnabled &&
                        _eventNotificationEnabled &&
                        _moneyNotificationEnabled;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('이벤트 알림'),
                value: _eventNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _eventNotificationEnabled = value;
                    _allNotificationEnabled = _likeNotificationEnabled &&
                        _commentNotificationEnabled &&
                        _chatNotificationEnabled &&
                        _eventNotificationEnabled &&
                        _moneyNotificationEnabled;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SwitchListTile(
                title: Text('정산 알림'),
                value: _moneyNotificationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _moneyNotificationEnabled = value;
                    _allNotificationEnabled = _likeNotificationEnabled &&
                        _commentNotificationEnabled &&
                        _chatNotificationEnabled &&
                        _eventNotificationEnabled &&
                        _moneyNotificationEnabled;
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
