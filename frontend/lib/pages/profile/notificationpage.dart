import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('알림 없음'),
      ),
    );
  }
}
