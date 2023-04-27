import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';

class KnowHowDetail extends StatefulWidget {
  const KnowHowDetail({Key? key}) : super(key: key);
  @override
  _KnowHowDetailState createState() => _KnowHowDetailState();
}

Map<dynamic, dynamic> content = {
  "id": 1,
  "title": "톡톡 튀는 청바지 리폼 Tip!",
  "userimage": "assets/image/test.jpg",
  "username": "리폼왕춘식이",
  "content": [
    {
      "image": "assets/image/image 1.png",
      "text": "청바지를 잘라서 만든 청치마예요^^ 아랫 단은 자연스럽게 잘랐더니 더 예쁜 것 같아요~~"
    },
    {
      "image": "assets/image/image 2.png",
      "text": "이건 긴바지로 입다가 여름에 입으려고 잘라봤어요~ 레이스 붙이니까 더 특별한 것 같아요!"
    },
    {
      "image": "assets/image/image 3.png",
      "text": "진회색 청바지인데 제가 발톱으로 긁어놔서 자연스럽게 스크래치가 생겼어요^^"
    },
    {
      "image": "assets/image/image 10.png",
      "text": "이것도...^^ 저보다 스크래치 잘 만들 수 있는 고양 나와봐요~~ "
    },
  ],
  "created_at": "2023-04-27",
  "heart": 5,
  "comment": 10
};

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
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "NanumSquare"),
        )
      ],
    );
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
              smallProfile(content["userimage"], content["username"]),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Text(
                    content["created_at"],
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
                  itemCount: content["content"].length,
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
                                content["content"][index]["image"],
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
                                      content["content"][index]["text"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                        height: 1.4,
                                      ),
                                    ))
                                  ])),
                        ]);
                  }))
        ],
      ))
    ])));
  }
}
