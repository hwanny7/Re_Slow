import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reslow/pages/chat/chatdetail.dart';
import 'package:reslow/providers/socket_provider.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/widgets/common/profile_small.dart';

class Chat extends StatefulWidget {
  // dynamic socketManager;
  // Chat({Key? key, this.socketManager}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

List<Map<String, dynamic>> content = [
  {
    "id": 1,
    "time": "2023-05-04T00:00:00",
    "userimage": "assets/image/user.png",
    "username": "춘식이 집사",
    "recentText": "고양이 밥그릇 사고 싶은데 다 팔렸나요??ㅠㅠ",
    "unseenTextCnt": 3
  },
  {
    "id": 2,
    "time": "2023-05-03T00:00:00",
    "userimage": "assets/image/user.png",
    "username": "춘식이 집사2",
    "recentText": "고양이 밥그릇 대박임",
    "unseenTextCnt": 0
  },
  {
    "id": 3,
    "time": "2023-05-03T00:00:00",
    "userimage": "assets/image/user.png",
    "username": "춘식이 집사3",
    "recentText": "고양이 밥그릇 사고 싶은데 다 팔렸나요??ㅠㅠ",
    "unseenTextCnt": 0
  }
];

Map unseen = {};

List order = [];

class _ChatState extends State<Chat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // content = context.watch<SocketManager>().recentData;
      // unseen = context.watch<SocketManager>().unseenMsg;
      // order = context.watch<SocketManager>().chatOrder.toList();
    });
  }

  Widget chatList(int index) {
    return InkWell(
        onTap: () {
          // Navigate to the CalendarSelection page when the icon is clicked
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetail(chatNo: index),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 0.5)),
                  margin: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        content[index]["userimage"],
                        width: 50,
                      ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              content[index]["username"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(formatTimeDifference(content[index]["time"]))
                          ])),
                  Container(
                      margin: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                      child: Text(
                        content[index]["recentText"],
                        style: const TextStyle(fontSize: 14),
                      ))
                ],
              )
            ]),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(16),
            child: const Text(
              '채팅',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ))
      ]),
      Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: const Color(0xffDBDBDB)),
      Expanded(
          child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (context, index) {
          return chatList(index);
        },
      ))
    ]);
  }
}
