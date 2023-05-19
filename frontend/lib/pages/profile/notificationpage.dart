import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:reslow/utils/dio_client.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final DioClient dioClient = DioClient();
  List<NotificationModel> notifications = [];
  bool loading = true;

  Future<void> fetchNotifications() async {
    try {
      Map<String, dynamic> queryParams = {
        'page': 0,
        'size': 10,
      };
      Response response =
          await dioClient.dio.get('/notices', queryParameters: queryParams);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;

        setState(() {
          loading = false;
          notifications = jsonData
              .map<NotificationModel>(
                  (notification) => NotificationModel.fromJson(notification))
              .toList();
        });
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final response = await dioClient.dio.delete('/notices/-1');
      if (response.statusCode == 200) {
        setState(() {
          notifications.clear();
        });
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

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
            child: loading
                ? Center(
                    child: CircularProgressIndicator(), // 로딩중
                  )
                : notifications.isEmpty
                    ? Center(
                        child: Text(
                          '받은 알림이 없습니다.',
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size as desired
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 80, 80, 80),
                          ),
                        ), // 알림 없음
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: 20.0), // Set the desired right padding
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton(
                                onPressed: deleteAllNotifications,
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors
                                          .green)), // Set the outline color
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.green.withOpacity(
                                          0.1)), // Set the overlay color
                                ),
                                child: Text(
                                  '전체 삭제',
                                  style: TextStyle(
                                    fontSize:
                                        18, // Adjust the font size as desired
                                    color:
                                        const Color.fromARGB(255, 80, 80, 80),
                                  ),
                                ), // 전체 삭제 버튼
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (BuildContext context, int index) {
                                NotificationModel notification =
                                    notifications[index];
                                final noticeNo = notification.noticeNo;
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.notifications,
                                            size: 30,
                                            color: Colors.green.shade400),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notification.title ?? '',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                notification.senderNickname ??
                                                    '',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                notification.time ?? '',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // 알림 개별 삭제
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle,
                                            size: 22,
                                            color: Colors.red.shade400,
                                          ),
                                          onPressed: () async {
                                            final response = await dioClient.dio
                                                .delete('/notices/$noticeNo');
                                            if (response.statusCode == 200) {
                                              setState(() {
                                                notifications
                                                    .remove(notification);
                                              });
                                            } else {
                                              print(
                                                  'HTTP request failed with status: ${response.statusCode}');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    ));
  }
}

class NotificationModel {
  final int noticeNo;
  final String title;
  final String senderNickname;
  final String type;
  final String time;

  NotificationModel({
    required this.noticeNo, // 보여줄 X
    required this.title,
    required this.senderNickname,
    required this.type, // 보여줄 X
    required this.time,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> responseData) {
    return NotificationModel(
      noticeNo: responseData['noticeNo'],
      title: responseData['title'],
      senderNickname: responseData['senderNickname'],
      type: responseData['type'],
      time: responseData['time'],
    );
  }
}
