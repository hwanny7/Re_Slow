// 사진 개수에 따라 사진 배치가 달라집니다.
// 0인 경우, 사진이 없는 게시물입니다.라는 문구
// 1인 경우, 한 개의 사진으로 꽉 채움
// 2인 경우, 공간을 세로로 분할하여 사진 배치
// 3인 경우, 왼쪽 공간에 1번 사진, 오른쪽 공간을 위 아래로 갈라서 2, 3번 사진 배치
// 4인 경우, 십자 모양으로 공간 분리 후 배치
// 5이상인 경우, 십자 모양으로 공간 분리 후 배치 + 오른쪽 아래 사진 위에 남은 사진 개수 표시
// 사용 예시: KnowHowGrid(images: [imgURL, imgURL, imgURL, imgURL], imageLTH: 5)

import 'package:flutter/material.dart';

class ProfileSmall extends StatefulWidget {
  final String? url;
  final String name;

  const ProfileSmall({Key? key, required this.url, required this.name})
      : super(key: key);

  @override
  _ProfileSmallState createState() => _ProfileSmallState();
}

class _ProfileSmallState extends State<ProfileSmall> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 12, 8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: widget.url == null
                    ? Image.asset(
                        "assets/image/user.png",
                        width: 50,
                      )
                    : Image.network(widget.url.toString(), width: 50))),
        Text(
          widget.name,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "NanumSquare"),
        )
      ],
    );
  }
}
