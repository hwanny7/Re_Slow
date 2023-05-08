import 'package:flutter/material.dart';
import 'notificationmessage.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/utils/dio_client.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final DioClient dioClient = DioClient();

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
                    // Pass the notifications list to the widget
                    // notifications: notifications,
                    // Pass the index of the notification being deleted
                    // noticeNo 삭제 버튼 클릭한 알림의 index를 함께 보내줘야... notificationNo를 백에서 주는건지 내가 매겨야 하는건지?
                    onDeletePressed: (index) async {
                      final noticeNo = notifications[index]['noticeNo'];
                      final response = await dioClient.dio
                          .delete('/notices/$noticeNo'); // 알림 삭제
                      if (response.statusCode == 200) {
                        setState(() {
                          notifications.removeAt(index);
                        });
                      } else {
                        print(
                            'HTTP request failed with status: ${response.statusCode}');
                      }
                    },
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
