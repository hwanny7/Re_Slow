import 'package:flutter/material.dart';

class MyKnowhow extends StatefulWidget {
  const MyKnowhow({Key? key}) : super(key: key);

  @override
  _MyKnowhowState createState() => _MyKnowhowState();
}

class _MyKnowhowState extends State<MyKnowhow> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(children: [Text("내가 쓴 노하우 글")])));
  }
}
