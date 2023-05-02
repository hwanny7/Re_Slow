// 사진 개수에 따라 사진 배치가 달라집니다.
// 0인 경우, 사진이 없는 게시물입니다.라는 문구
// 1인 경우, 한 개의 사진으로 꽉 채움
// 2인 경우, 공간을 세로로 분할하여 사진 배치
// 3인 경우, 왼쪽 공간에 1번 사진, 오른쪽 공간을 위 아래로 갈라서 2, 3번 사진 배치
// 4인 경우, 십자 모양으로 공간 분리 후 배치
// 5이상인 경우, 십자 모양으로 공간 분리 후 배치 + 오른쪽 아래 사진 위에 남은 사진 개수 표시
// 사용 예시: KnowHowGrid(images: [imgURL, imgURL, imgURL, imgURL], imageLTH: 5)

import 'package:flutter/material.dart';

class KnowHowGrid extends StatefulWidget {
  final List images;
  final int imageLTH;

  const KnowHowGrid({Key? key, required this.images, required this.imageLTH})
      : super(key: key);

  @override
  _KnowHowGridState createState() => _KnowHowGridState();
}

class _KnowHowGridState extends State<KnowHowGrid> {
  late double fullWidth;
  late double fullHeight;
  // 사진 개수에 따라 사진 배치
  @override
  Widget build(BuildContext context) {
    fullWidth = MediaQuery.of(context).size.width * 0.98;
    fullHeight = MediaQuery.of(context).size.height * 0.3;
    int imagenumber = widget.imageLTH;
    // 사진 없을 때
    if (imagenumber == 0) {
      return const Text("사진이 없는 게시물입니다.");
      // 사진 한 개일 때
    } else if (imagenumber == 1) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(0.0),
          child: Image.asset(
            widget.images[0],
            width: fullWidth,
            height: fullHeight,
            fit: BoxFit.cover,
          ));
      // 사진 두 개일 때
    } else if (imagenumber == 2) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  widget.images[0],
                  width: fullWidth / 2,
                  height: fullHeight,
                  fit: BoxFit.cover,
                ))),
        Container(
            margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  widget.images[1],
                  width: fullWidth / 2,
                  height: fullHeight,
                  fit: BoxFit.cover,
                )))
      ]);
      // 사진 세 개일 때
    } else if (imagenumber == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Image.asset(
                    widget.images[0],
                    width: fullWidth / 2,
                    height: fullHeight,
                    fit: BoxFit.cover,
                  ))),
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(2, 0, 0, 2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[1],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[2],
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
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[0],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[1],
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
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[2],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[3],
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[0],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[1],
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
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        widget.images[2],
                        width: fullWidth / 2,
                        height: fullHeight / 2,
                        fit: BoxFit.cover,
                      ))),
              Container(
                  margin: const EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.asset(
                            widget.images[3],
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
}
