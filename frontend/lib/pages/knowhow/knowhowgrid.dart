import 'package:flutter/material.dart';

class KnowHow extends StatefulWidget {
  @override
  _KnowHowState createState() => _KnowHowState();
}

class _KnowHowState extends State<KnowHow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      const Text("여기에 검색바랑 카테고리"),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      Container(
          margin: const EdgeInsets.all(16),
          child: Center(
              child: Column(
                  children: [Image.asset("assets/image/Logo_Reslow.png")]))),
    ]));
  }
}
