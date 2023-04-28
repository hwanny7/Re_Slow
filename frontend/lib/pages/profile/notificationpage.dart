import 'package:flutter/material.dart';
import 'notificationmessage.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

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
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: '알림'),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              width: double.infinity,
            ),
          ),
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
    ));
  }
}
