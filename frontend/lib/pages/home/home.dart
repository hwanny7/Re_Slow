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
    return Container(
        child: Column(children: [
      Container(
          margin: EdgeInsets.all(16),
          child: Center(
              child: Column(
                  children: [Image.asset("assets/image/Logo_Reslow.png")]))),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Center(
              child: Column(children: [
            Image.asset("assets/image/coupon 1.png", width: 350)
          ])))
    ]));
  }
}
