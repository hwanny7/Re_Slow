import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';

class KnowHow extends StatefulWidget {
  @override
  _KnowHowState createState() => _KnowHowState();
}

List<dynamic> content = [
  {
    "title": "톡톡 튀는 청바지 리폼 Tip!",
    "userimage": "assets/image/test.jpg",
    "username": "리폼왕춘식이",
    "imagelist": [
      "assets/image/image 1.png",
      "assets/image/image 2.png",
      "assets/image/image 3.png",
      "assets/image/image 10.png"
    ],
    "heart": 5,
    "comment": 10
  },
  {
    "title": "춘식의 서적 리폼 노하우\u{1f60d}",
    "userimage": "assets/image/test.jpg",
    "username": "리폼왕춘식이",
    "imagelist": [
      "assets/image/image 4.png",
      "assets/image/image 5.png",
      "assets/image/image 6.png",
    ],
    "heart": 7,
    "comment": 10
  },
];

class _KnowHowState extends State<KnowHow> {
  late double fullWidth;
  late double fullHeight;
  // 사진 개수에 따라 사진 배치
  Widget imageGrid(List images) {
    fullWidth = MediaQuery.of(context).size.width * 0.92;
    fullHeight = MediaQuery.of(context).size.height * 0.3;
    int imagenumber = images.length;
    // 사진 없을 때
    if (imagenumber == 0) {
      return const Text("사진이 없는 게시물입니다.");
      // 사진 한 개일 때
    } else if (imagenumber == 1) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            images[0],
            width: fullWidth,
            height: fullHeight,
            fit: BoxFit.cover,
          ));
      // 사진 두 개일 때
    } else if (imagenumber == 2) {
      return Row(children: [
        Container(
            margin: const EdgeInsets.all(2),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  images[0],
                  width: fullWidth / 2,
                  height: fullHeight,
                  fit: BoxFit.cover,
                ))),
        Container(
            margin: const EdgeInsets.all(2),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  images[1],
                  width: fullWidth / 2,
                  height: fullHeight,
                  fit: BoxFit.cover,
                )))
      ]);
      // 사진 세 개일 때
    } else if (imagenumber == 3) {
      return Row(
        children: [
          Container(
              margin: const EdgeInsets.all(2),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    images[0],
                    width: fullWidth / 2,
                    height: fullHeight,
                    fit: BoxFit.cover,
                  ))),
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[1],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[2],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      )))
            ],
          )
        ],
      );
      // 사진이 네 개일 때
    } else if (imagenumber == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[0],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[1],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      )))
            ],
          ),
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[2],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[3],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      )))
            ],
          )
        ],
      );
      // 사진이 다섯 개 이상일 때
    } else {
      return Row(
        children: [
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[0],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[1],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      )))
            ],
          ),
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        images[2],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            images[3],
                            width: fullWidth / 2,
                            height: fullHeight / 2,
                            fit: BoxFit.cover,
                          )),
                      Positioned(
                          top: (fullHeight - 120) / 2,
                          left: (fullWidth - 120) / 2,
                          child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xffDBDBDB).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                  child: Text(
                                "+${imagenumber - 4}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ))))
                    ],
                  ))
            ],
          )
        ],
      );
    }
  }

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
      Align(alignment: Alignment.center, child: MySearchBar()),
      const CategoryTapBar(),
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
                            smallProfile(content[index]["userimage"],
                                content[index]["username"]),
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
                    Container(
                        width: MediaQuery.of(context).size.width * 0.94,
                        margin: const EdgeInsets.all(8),
                        child: Center(
                            child: Column(children: [
                          Center(child: imageGrid(content[index]["imagelist"]))
                        ]))),
                    Container(
                        margin: const EdgeInsets.all(16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                content[index]["title"],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Image.asset(
                                        "assets/image/heart.png",
                                        width: 24,
                                      )),
                                  Text(
                                    "${content[index]["heart"]}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Image.asset(
                                        "assets/image/comment.png",
                                        width: 24,
                                      )),
                                  Text(
                                    "${content[index]["comment"]}",
                                    style: const TextStyle(fontSize: 18),
                                  )
                                ],
                              )
                            ])),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 8,
                        color: const Color(0xffDBDBDB)),
                  ],
                );
              })),
    ]);
  }
}
