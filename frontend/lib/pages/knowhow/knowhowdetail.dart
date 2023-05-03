// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/pages/knowhow/knowhowcomment.dart';
import 'package:reslow/pages/profile/myKnowhow.dart';
import 'package:reslow/widgets/common/profile_small.dart';

class KnowHowDetail extends StatefulWidget {
  const KnowHowDetail({Key? key}) : super(key: key);
  @override
  _KnowHowDetailState createState() => _KnowHowDetailState();
}

Map<dynamic, dynamic> content = {
  "knowhowNo": 1,
  "title": "톡톡 튀는 청바지 리폼 Tip!",
  "profilePic": "assets/image/test.jpg",
  "writer": "리폼왕춘식이",
  "contentList": [
    {
      "order": 1,
      "contentNo": 1,
      "image": "assets/image/image 1.png",
      "content": "청바지를 잘라서 만든 청치마예요^^ 아랫 단은 자연스럽게 잘랐더니 더 예쁜 것 같아요~~"
    },
    {
      "order": 2,
      "contentNo": 1,
      "image": "assets/image/image 2.png",
      "content": "이건 긴바지로 입다가 여름에 입으려고 잘라봤어요~ 레이스 붙이니까 더 특별해요!"
    },
    {
      "order": 3,
      "contentNo": 3,
      "image": "assets/image/image 3.png",
      "content": "진회색 청바지인데 제가 발톱으로 긁어놔서 자연스럽게 스크래치가 생겼어요^^"
    },
    {
      "order": 4,
      "contentNo": 4,
      "image": "assets/image/image 10.png",
      "content": "이것도...^^ 저보다 스크래치 잘 만들 수 있는 고양 나와봐요~~ "
    },
  ],
  "date": "2023-04-27",
  "heart": 5,
  "comment": 10
};

Map heartYN = {"YN": true};

var url = Uri.base.toString();

class _KnowHowDetailState extends State<KnowHowDetail> {
  Dio dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    _requestKnowhow().then((data) {
      print(data);
      setState(() {
        content = data as Map;
      });
    });
    super.initState();
  }

  Future<List> _requestKnowhow() async {
    final response = await dio.get('http://k8b306.p.ssafy.io:8080/knowhows/');
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final int id = arguments['id'];

    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      Expanded(
          child: Column(
        children: [
          TextButton(
              onPressed: () {
                // Navigate to my account settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyKnowhow()), //나의 노하우 글 페이지로 이동
                );
              },
              child: Text("나의 노하우 글 보기")),
          Container(
              margin: const EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(content["title"],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ))),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffDBDBDB)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileSmall(url: content["profilePic"], name: content["writer"]),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Text(
                    content["date"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                    ),
                  ))
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffDBDBDB)),
          Expanded(
              child: ListView.builder(
                  itemCount: content["contentList"].length,
                  itemBuilder: (context, index) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: Image.asset("assets/image/dots.png",
                                  width: 30)),
                          Container(
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Image.asset(
                                content["contentList"][index]["image"],
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )),
                          Container(
                              margin: const EdgeInsets.all(16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      content["contentList"][index]["content"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        height: 1.4,
                                      ),
                                    ))
                                  ])),
                        ]);
                  })),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffDBDBDB)),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              heartYN["YN"] = !heartYN["YN"];
                            });
                          },
                          child: Row(children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Image.asset(
                                  heartYN["YN"]
                                      ? "assets/image/full_heart.png"
                                      : "assets/image/heart.png",
                                  width: 24,
                                )),
                            Text(
                              "${content["heart"]}",
                              style: const TextStyle(fontSize: 18),
                            )
                          ])),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Knowhowcomment(knowhowid: id),
                                  ),
                                )
                              },
                          child: Row(children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Image.asset(
                                  "assets/image/comment.png",
                                  width: 24,
                                )),
                            Text(
                              "${content["comment"]}",
                              style: const TextStyle(fontSize: 18),
                            )
                          ])),
                    ],
                  )
                ],
              ))
        ],
      ))
    ])));
  }
}
