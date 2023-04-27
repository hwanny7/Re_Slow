import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'coupondownload.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<dynamic> couponImage = [
    "assets/image/coupon 1.png",
    "assets/image/coupon 2.png",
    "assets/image/coupon 3.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Container(
          margin: const EdgeInsets.all(16),
          child: Center(
              child: Column(
                  children: [Image.asset("assets/image/Logo_Reslow.png")]))),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      // 쿠폰 시작
      // Container(
      //   margin: const EdgeInsets.fromLTRB(0, 24, 0, 16),
      //   child: Center(
      //     child: CarouselSlider(
      //       options: CarouselOptions(autoPlay: true, height: 130.0),
      //       items: couponImage.map((item) {
      //         return Container(
      //           width: MediaQuery.of(context).size.width,
      //           margin: const EdgeInsets.symmetric(horizontal: 5.0),
      //           decoration: const BoxDecoration(color: Colors.white),
      //           child: ClipRRect(
      //               borderRadius: BorderRadius.circular(10.0),
      //               child: Image.asset(
      //                 item,
      //                 fit: BoxFit.cover,
      //               )),
      //         );
      //       }).toList(),
      //     ),
      //   ),
      // ),
      // 쿠폰 끝
      // 쿠폰에 이미지 클릭 넣기 시작 - 모든 쿠폰이 동일하게 들어가기는 함
      Container(
        margin: const EdgeInsets.fromLTRB(0, 24, 0, 16),
        child: Center(
          child: CarouselSlider(
            options: CarouselOptions(autoPlay: true, height: 130.0),
            items: couponImage.map((item) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(color: Colors.white),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CouponDownload(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      item,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      // 쿠폰에 이미지 클릭 넣기 끝
      Container(width: 600, height: 12, color: const Color(0xffF4F2F2)),
      Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(16, 4, 0, 4),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("의류 리폼, 이렇게 해봐요!\u{1f609}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text("더보기"),
            )
          ])),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "assets/image/image 1.png",
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ))),
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 2.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 3.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
      ),
      Container(width: 600, height: 12, color: const Color(0xffF4F2F2)),
      Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(16, 4, 0, 4),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("서적 리폼, 이렇게 해봐요!\u{1f4d3}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text("더보기"),
            )
          ])),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 4.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 5.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 6.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
      ),
      Container(width: 600, height: 12, color: const Color(0xffF4F2F2)),
      Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(16, 4, 0, 4),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("이 제품 좋아하실 것 같아요\u{1f49d}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text("더보기"),
            )
          ])),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 7.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 8.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/image/image 9.png",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
      ),
    ]));
  }
}
