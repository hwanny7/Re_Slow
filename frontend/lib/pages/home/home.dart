import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int number = 0;
  void onPressed() {
    setState(() {
      number++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Home입니다.'));
  }
}
