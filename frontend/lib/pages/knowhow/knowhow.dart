import 'package:flutter/material.dart';

class KnowHow extends StatefulWidget {
  @override
  _KnowHowState createState() => _KnowHowState();
}

class _KnowHowState extends State<KnowHow> {
  // 사진 개수에 따라 사진 배치
  double fullWidth = 400;
  double fullHeight = 300;
  Widget imageGrid(List images, int imagenumber) {
    // 사진 없을 때
    if (imagenumber == 0) {
      return const Text("사진이 없는 게시물입니다.");
      // 사진 한 개일 때
    } else if (imagenumber == 1) {
      return Image.asset(
        images[0],
        width: fullWidth,
        height: fullHeight,
      );
      // 사진 두 개일 때
    } else if (imagenumber == 2) {
      return Column(children: [
        Container(
            margin: const EdgeInsets.all(8),
            child: Image.asset(images[0],
                width: fullWidth / 2, height: fullHeight)),
        Container(
            margin: const EdgeInsets.all(8),
            child: Image.asset(images[1],
                width: fullWidth / 2, height: fullHeight))
      ]);
      // 사진 세 개일 때
    } else if (imagenumber == 3) {
      return Column(
        children: [
          Container(
              margin: const EdgeInsets.all(8),
              child: Image.asset(images[0],
                  width: fullWidth / 2, height: fullHeight)),
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[1],
                      width: fullWidth / 2, height: fullHeight / 2)),
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[2],
                      width: fullWidth / 2, height: fullHeight / 2))
            ],
          )
        ],
      );
      // 사진이 네 개일 때
    } else if (imagenumber == 4) {
      return Column(
        children: [
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[0],
                      width: fullWidth / 2, height: fullHeight / 2)),
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[1],
                      width: fullWidth / 2, height: fullHeight / 2))
            ],
          ),
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[2],
                      width: fullWidth / 2, height: fullHeight / 2)),
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[3],
                      width: fullWidth / 2, height: fullHeight / 2))
            ],
          )
        ],
      );
      // 사진이 다섯 개 이상일 때
    } else {
      return Column(
        children: [
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[0],
                      width: fullWidth / 2, height: fullHeight / 2)),
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[1],
                      width: fullWidth / 2, height: fullHeight / 2))
            ],
          ),
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Image.asset(images[2],
                      width: fullWidth / 2, height: fullHeight / 2)),
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Image.asset(images[3],
                          width: fullWidth / 2, height: fullHeight / 2),
                      Text("+${imagenumber - 4}")
                    ],
                  ))
            ],
          )
        ],
      );
    }
  }

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
