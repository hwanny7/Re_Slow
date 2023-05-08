import 'package:flutter/material.dart';

class NotificationMessage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Function onDeletePressed; // Callback function

  const NotificationMessage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onDeletePressed, // Pass callback function as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications, size: 20, color: Colors.purple.shade400),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(subtitle),
                SizedBox(height: 5),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          // 알림 삭제 버튼
          IconButton(
            icon:
                Icon(Icons.remove_circle, size: 20, color: Colors.red.shade400),
            onPressed: () => onDeletePressed(), // notificationpage에서 index정의
          ),
        ],
      ),
    );
  }
}
