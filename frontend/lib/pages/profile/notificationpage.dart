import 'package:flutter/material.dart';
import 'notificationmessage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, String>> notifications = [
    {'title': '새로운 채팅', 'subtitle': '춘장 라이언으로부터 채팅이 도착했어요!', 'time': '1시간 전'},
    {'title': '새로운 알림', 'subtitle': '상품을 받으셨다면 구매확정을 해주세요!', 'time': '3일 전'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  '알림',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: NotificationMessage(
                    title: notification['title'] ?? '',
                    subtitle: notification['subtitle'] ?? '',
                    time: notification['time'] ?? '',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
