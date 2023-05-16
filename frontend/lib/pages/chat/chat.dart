import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reslow/pages/chat/chatdetail.dart';
import 'package:reslow/providers/socket_provider.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/widgets/common/profile_small.dart';

class Chat extends StatefulWidget {
  // dynamic socketManager;
  // Chat({Key? key, this.socketManager}) : super(key: key);
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

List<dynamic> content = [];

Map unseen = {};

List order = [];

class _ChatState extends State<Chat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestRoomList();
    setState(() {
      // content = context.watch<SocketManager>().recentData;
      // unseen = context.watch<SocketManager>().unseenMsg;
      // order = context.watch<SocketManager>().chatOrder.toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _requestRoomList() async {
    try {
      dioClient.dio.get('/chat/roomList').then((res) {
        setState(() {
          content = res.data;
        });
        print(content);
      });
    } on DioError catch (e) {
      print('chatListerror: $e');
    }
  }

  void _refresh() {
    _requestRoomList();
  }

  Widget chatList(int index) {
    return InkWell(
        onTap: () {
          // Navigate to the CalendarSelection page when the icon is clicked
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetail(
                  roomId: content[index]["roomId"],
                  otherPic: content[index]["profilePic"] ?? "",
                  otherNick: content[index]["nickname"],
                  refresh: _refresh),
            ),
          ).then((res) {
            _requestRoomList();
          });
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
                      child: content[index]["profilePic"] == null
                          ? Image.asset(
                              "assets/image/user.png",
                              width: 50,
                              height: 50,
                            )
                          : Image.network(
                              content[index]["profilePic"],
                              width: 50,
                              height: 50,
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
                              content[index]["nickname"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(formatTimeDifference(
                                content[index]["dateTime"].toString()))
                          ])),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      margin: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                      child: Text(
                        content[index]["lastMessage"],
                        overflow: TextOverflow.ellipsis,
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
          child: RefreshIndicator(
              onRefresh: () async {
                // Perform the refresh operation here
                // You can call an API, update data, or perform any other action
                // Make sure to await any asynchronous operation

                // Example: Simulating a delay of 2 seconds before completing the refresh
                await Future.delayed(Duration(seconds: 2));

                // Once the refresh operation is completed, update the UI as needed
                _requestRoomList();
              },
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                    itemCount: content.length,
                    itemBuilder: (context, index) {
                      return chatList(index);
                    },
                  ))))
    ]);
  }
}
