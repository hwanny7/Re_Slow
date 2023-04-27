import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';

class KnowHowDetail extends StatefulWidget {
  const KnowHowDetail({Key? key}) : super(key: key);
  @override
  _KnowHowDetailState createState() => _KnowHowDetailState();
}

List<dynamic> content = [
  {
    "title": "톡톡 튀는 청바지 리폼 Tip!",
    "userimage": "assets/image/test.jpg",
    "username": "리폼왕춘식이",
    "content": [
      {"image": "assets/image/image 1.png", "text": "청바지바지밥바바1"},
      {"image": "assets/image/image 2.png", "text": "청바지바지밥바바2"},
      {"image": "assets/image/image 3.png", "text": "청바지바지밥바바3"},
      {"image": "assets/image/image 10.png", "text": "청바지바지밥바바4"},
    ],
    "heart": 5,
    "comment": 10
  },
  {
    "title": "춘식의 서적 리폼 노하우\u{1f60d}",
    "userimage": "assets/image/test.jpg",
    "username": "리폼왕춘식이",
    "content": [
      {"image": "assets/image/image 4.png", "text": "서적책책북책"},
      {"image": "assets/image/image 5.png", "text": "체키쳌checkyyyy"},
      {"image": "assets/image/image 6.png", "text": "책책check책3"},
    ],
    "heart": 7,
    "comment": 10
  },
];

class _KnowHowDetailState extends State<KnowHowDetail> {
  Widget smallProfile(String imageaddress, String name) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 12, 8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  imageaddress,
                  width: 50,
                ))),
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.builder(
              itemCount: content.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // Image.asset(content[index]["content"]["image"]),
                    // Text(content[index]["content"]["text"])
                  ],
                );
              })),
    ]);
  }
}
