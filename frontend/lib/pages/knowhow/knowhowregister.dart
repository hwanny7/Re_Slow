import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KnowhowRegister extends StatefulWidget {
  const KnowhowRegister({Key? key}) : super(key: key);

  @override
  _KnowhowRegisterState createState() => _KnowhowRegisterState();
}

class _KnowhowRegisterState extends State<KnowhowRegister> {
  int selected = -1;

  Widget categoryTag(int index, String tagname) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all<Color>(const Color(0xff555555)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                  width: 2,
                  color: selected == index
                      ? const Color(0xff165B40)
                      : const Color(0xffE0E0E0)),
            ),
          ),
        ),
        child: Text(tagname),
        onPressed: () {
          setState(() => selected = index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(children: [
        Container(
            margin: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width * 0.7,
            child: const Text(
              "노하우 글쓰기",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: const Color(0xffDBDBDB)),
        Row(children: [
          Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 8, 0),
              width: MediaQuery.of(context).size.width * 0.16,
              child: const Text(
                "카테고리",
                style: TextStyle(fontSize: 16),
              )),
          Container(width: 1, height: 30, color: const Color(0xffDBDBDB)),
          Container(
              color: Colors.grey.withOpacity(0.03),
              width: MediaQuery.of(context).size.width * 0.74,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        categoryTag(1, "의류"),
                        categoryTag(2, "서적"),
                        categoryTag(3, "가구"),
                        categoryTag(4, "악세사리"),
                        categoryTag(5, "잡화"),
                        categoryTag(6, "잘 넘어가니?")
                      ])))
        ]),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: const Color(0xffDBDBDB)),
      ]),
    ));
  }
}
