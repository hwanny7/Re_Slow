import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/socket_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'coupondownload.dart';
import 'package:reslow/utils/navigator.dart';
import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int _current = 0;
  final DioClient dioClient = DioClient();
  final CarouselController _controller = CarouselController();
  // List<dynamic> couponImage = [];
  List<Coupon> coupons = [];

  Future<void> fetchData() async {
    Map<String, dynamic> queryParams = {
      'page': 0,
      'size': 10,
      'sort': 'createdDate,desc',
    };
    Response response =
        await dioClient.dio.get('/coupons', queryParameters: queryParams);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData);

      List<Coupon> fetchedCoupons = List<Coupon>.from(
          jsonData['content'].map((itemJson) => Coupon.fromJson(itemJson)));

      setState(() {
        coupons = fetchedCoupons;
        // couponImage = fetchedCoupons.map((coupon) => coupon.imageUrl).toList();
      });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.removeObserver(this);
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // dynamic socketManager = Provider.of<SocketManager>(context);
    // socketManager.receivedChatData();

    // @override
    // void didChangeAppLifecycleState(AppLifecycleState state) {
    //   super.didChangeAppLifecycleState(state);
    //   switch (state) {
    //     case AppLifecycleState.resumed:
    //       socketManager.connect();
    //       // 서버로 open 보내기
    //       print("resumed");
    //       break;
    //     case AppLifecycleState.inactive:
    //       socketManager.disconnect();
    //       // 서버로 close 보내기
    //       print("inactive");
    //       break;
    //     case AppLifecycleState.detached:
    //       socketManager.disconnect();
    //       // 서버로 close 보내기
    //       print("detached");
    //       break;
    //     case AppLifecycleState.paused:
    //       socketManager.disconnect();
    //       // 서버로 close 보내기
    //       print("paused");
    //       break;
    //   }
    // }

    // socketManager.connect();

    // print(socketManager.isConnect());

    return SingleChildScrollView(
        child: Column(children: [
      Container(
          margin: const EdgeInsets.all(16),
          child: Center(
              child: Column(
                  children: [Image.asset("assets/image/Logo_Reslow.png")]))),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      // 쿠폰에 이미지 클릭 넣기 시작 - 모든 쿠폰이 동일하게 들어가기는 함
      Container(
        margin: const EdgeInsets.fromLTRB(0, 24, 0, 16),
        child: Center(
          child: CarouselSlider(
            options: CarouselOptions(autoPlay: true, height: 130.0),
            items: coupons.map((item) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(color: Colors.white),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CouponDownload(),
                    //   ),
                    // );
                    leftToRightNavigator(
                        CouponDownload(couponPk: item.couponNo),
                        context); // 수정 필요
                    // 클릭한 해당 쿠폰의 쿠폰 넘버
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      item.imageUrl,
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

class Coupon {
  final int couponNo;
  final String name;
  final String content;
  final int discountType;
  final int discountAmount;
  final int discountPercent;
  final String startDate;
  final String endDate;
  final String imageUrl;

  Coupon({
    required this.couponNo,
    required this.name,
    required this.content,
    required this.discountType,
    required this.discountAmount,
    required this.discountPercent,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  factory Coupon.fromJson(Map<String, dynamic> responseData) {
    print('responseData: $responseData'); // 프린트
    return Coupon(
        couponNo: responseData['couponNo'],
        name: responseData['name'],
        content: responseData['startDate'],
        discountType: responseData['discountType'],
        discountAmount: responseData['discountAmount'],
        discountPercent: responseData['discountPercent'],
        startDate: responseData['startDate'],
        endDate: responseData['endDate'],
        imageUrl: responseData['imageUrl']);
  }
}
