import 'package:flutter/material.dart';

List<Map<String, dynamic>> content = [
  {
    "commentNo": 1,
    "memberNo": 1,
    "parentNo": null,
    "profilePic": null,
    "nickname": "리폼왕춘식이1",
    "datetime": "2023-04-27 12:00",
    "content": "댓글1",
    "children": [
      {
        "commentNo": 2,
        "memberNo": 1,
        "parentNo": 1,
        "profilePic": null,
        "nickname": "리폼왕춘식이111",
        "datetime": "2023-04-27 12:00",
        "content": "댓글2",
        "children": null
      },
      {
        "commentNo": 2,
        "memberNo": 1,
        "parentNo": 1,
        "profilePic": null,
        "nickname": "리폼왕춘식이222",
        "datetime": "2023-04-27 12:00",
        "content": "댓글2-1",
        "children": null
      }
    ]
  },
  {
    "commentNo": 1,
    "memberNo": 1,
    "parentNo": null,
    "profilePic": null,
    "nickname": "리폼왕춘식이2",
    "datetime": "2023-04-27 12:00",
    "content": "댓글3",
    "children": [
      {
        "commentNo": 2,
        "memberNo": 1,
        "parentNo": 1,
        "profilePic": null,
        "nickname": "리폼왕춘식이333",
        "datetime": "2023-04-27 12:00",
        "content": "댓글4",
        "children": null
      }
    ]
  }
];

class Knowhowcomment extends StatefulWidget {
  final int knowhowid;

  const Knowhowcomment({Key? key, required this.knowhowid}) : super(key: key);

  @override
  _KnowhowcommentState createState() => _KnowhowcommentState();
}

class _KnowhowcommentState extends State<Knowhowcomment> {
  Widget comment(double depth, int index) {
    return Row(children: [
      Container(
          margin: EdgeInsets.fromLTRB(16 + 16 * depth, 16, 16, 16),
          child: content[index]["profilePic"] == null
              ? Image.asset("assets/image/user.png")
              : Image.network(content[index]["profilePic"])),
      Column(
        children: [
          Text(
            content[index]["nickname"],
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            content[index]["content"],
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            content[index]["datetime"],
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w100),
          )
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              "댓글${content.length}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )),
      ]),
      Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: const Color(0xffDBDBDB)),
      Expanded(
          child: ListView.builder(
              itemCount: content.length,
              itemBuilder: (context, index) {
                return comment(0, index);
              }))
    ])));
  }
}
