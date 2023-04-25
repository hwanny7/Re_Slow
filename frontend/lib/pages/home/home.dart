import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'model/CouponClass.dart';

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
                child: Image.asset(
                  item,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
          ),
        ),
      ),
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
                child: Image.asset("assets/image/image 1.png"),
                margin: const EdgeInsets.all(8)),
            Container(
                child: Image.asset("assets/image/image 2.png"),
                margin: const EdgeInsets.all(8)),
            Container(
                child: Image.asset("assets/image/image 3.png"),
                margin: const EdgeInsets.all(8)),
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
              child: Image.asset("assets/image/image 4.png"),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: Image.asset("assets/image/image 5.png"),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: Image.asset("assets/image/image 6.png"),
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
                child: Image.asset("assets/image/image 7.png"),
                margin: const EdgeInsets.all(8)),
            Container(
                child: Image.asset("assets/image/image 8.png"),
                margin: const EdgeInsets.all(8)),
            Container(
                child: Image.asset("assets/image/image 9.png"),
                margin: const EdgeInsets.all(8)),
          ],
        ),
      ),
    ]));
  }
}
