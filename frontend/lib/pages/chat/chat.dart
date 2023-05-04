import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

List<Map> content = [];

class _ChatState extends State<Chat> {
  Widget _ChatList() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('채팅입니다.'),
    ]);
  }
}
