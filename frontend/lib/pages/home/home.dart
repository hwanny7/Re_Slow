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
    return Container(
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
                  decoration: BoxDecoration(color: Colors.white),
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
        Text("뭐야 이거")
      ]),
    );
  }
}
