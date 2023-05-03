import 'package:flutter/material.dart';
import 'package:reslow/pages/knowhow/knowhowcomment.dart';
import 'package:reslow/widgets/common/profile_small.dart';
import 'package:reslow/widgets/knowhow/knowhow_grid.dart';

class Mylikeknowhow extends StatefulWidget {
  const Mylikeknowhow({Key? key}) : super(key: key);

  @override
  _MylikeknowhowState createState() => _MylikeknowhowState();
}

List<dynamic> content = [
  {
    "knowhowNo": 1,
    "title": "톡톡 튀는 청바지 리폼 Tip!",
    "profile": "assets/image/test.jpg",
    "writer": "리폼왕춘식이",
    "pictureList": [
      "assets/image/image 1.png",
      "assets/image/image 2.png",
      "assets/image/image 3.png",
      "assets/image/image 10.png"
    ],
    "pictureCnt": 4,
    "likeCnt": 5,
    "commentCnt": 10
  },
  {
    "knowhowNo": 2,
    "title": "춘식의 서적 리폼 노하우\u{1f60d}",
    "profile": "assets/image/test.jpg",
    "writer": "리폼왕춘식이",
    "pictureList": [
      "assets/image/image 4.png",
      "assets/image/image 5.png",
      "assets/image/image 6.png",
    ],
    "pictureCnt": 3,
    "likeCnt": 7,
    "commentCnt": 10
  },
];

List<dynamic> heartYN = [
  {"YN": true},
  {"YN": false},
];

int _selectedindex = -1;

class _MylikeknowhowState extends State<Mylikeknowhow> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width * 0.7,
            child: const Text(
              "관심 노하우 글",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
                return Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileSmall(
                                url: content[index]["profilePic"],
                                name: content[index]["wirter"]),
                            Image.asset(
                              "assets/image/share.png",
                              width: 24,
                            )
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color(0xffDBDBDB)),
                    InkWell(
                        onTap: () => {
                              Navigator.pushNamed(context, '/knowhow/:id',
                                  arguments: {
                                    'id': content[index]["knowhowNo"]
                                  })
                            },
                        child: Column(children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(0),
                              child: Center(
                                  child: Column(children: [
                                Center(
                                    child: KnowHowGrid(
                                        images: content[index]["pictureList"],
                                        imageLTH: content[index]["pictureCnt"]))
                              ]))),
                          Container(
                              margin: const EdgeInsets.all(16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      content[index]["title"],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                heartYN[index]["YN"] =
                                                    !heartYN[index]["YN"];
                                              });
                                            },
                                            child: Row(children: [
                                              Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Image.asset(
                                                    heartYN[index]["YN"]
                                                        ? "assets/image/full_heart.png"
                                                        : "assets/image/heart.png",
                                                    width: 24,
                                                  )),
                                              Text(
                                                "${content[index]["likeCnt"]}",
                                                style: const TextStyle(
                                                    fontSize: 18),
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
                                                          Knowhowcomment(
                                                              knowhowid: content[
                                                                      index][
                                                                  "knowhowNo"]),
                                                    ),
                                                  )
                                                },
                                            child: Row(children: [
                                              Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Image.asset(
                                                    "assets/image/comment.png",
                                                    width: 24,
                                                  )),
                                              Text(
                                                "${content[index]["commentCnt"]}",
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              )
                                            ])),
                                      ],
                                    )
                                  ])),
                        ])),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 8,
                        color: const Color(0xffDBDBDB)),
                  ],
                );
              })),
    ])));
  }
}
