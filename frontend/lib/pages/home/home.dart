import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:reslow/pages/knowhow/knowhowdetail.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/pages/market/item_detail.dart';
import 'coupondownload.dart';
import 'package:reslow/utils/navigator.dart';
import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/models/recommend.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int _current = 0;
  final DioClient dioClient = DioClient();
  final CarouselController _controller = CarouselController();
  List<Coupon> coupons = [];
  List<dynamic> recommends1 = [];
  List<dynamic> recommends2 = [];
  List<dynamic> recommends3 = [];
  List<dynamic> displayrecommends3 = [];

  Future<void> fetchData() async {
    Map<String, dynamic> queryParams = {
      'page': 0,
      'size': 10,
      'sort': 'createdDate,desc',
    };

// 쿠폰
    Response response =
        await dioClient.dio.get('/coupons', queryParameters: queryParams);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData);
      List<Coupon> fetchedCoupons = List<Coupon>.from(
          jsonData['content'].map((itemJson) => Coupon.fromJson(itemJson)));
      setState(() {
        coupons = fetchedCoupons;
      });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
// 추천
    Response response1 = await dioClient.dio.get('/knowhows/recommends/main');
    Response response2 = await dioClient.dio.get('/products/recommends');
    Response response3 = await dioClient.dio.get('/products/recommends/orders');
    if (response1.statusCode == 200) {
      setState(() {
        recommends1 = (response1.data as List<dynamic>)
            .map((json) => Recommend1.fromJson(json))
            .toList();
      });
      print("들어온 데이터 ${response1}");
      print("추천1 ${recommends1[0].imageList[0]}");
    } else {
      print('HTTP request failed with status: ${response1.statusCode}');
    }
    if (response2.statusCode == 200) {
      setState(() {
        recommends2 = (response2.data as List<dynamic>)
            .map((json) => Recommend2.fromJson(json))
            .toList();
      });
      print("들어온 데이터 ${response2}");
      print("추천2 ${recommends2}");
    } else {
      print('HTTP request failed with status: ${response2.statusCode}');
    }
    if (response3.statusCode == 200) {
      setState(() {
        recommends3 = (response3.data as List<dynamic>)
            .map((json) => Recommend3.fromJson(json))
            .toList();
      });
      setState(() {
        displayrecommends3 = recommends3.sublist(0, 3);
      });
      print("들어온 데이터 ${response3}");
      print("추천3 ${recommends3}");
    } else {
      print('HTTP request failed with status: ${response3.statusCode}');
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

  void showAllList() {
    setState(() {
      displayrecommends3 = recommends3;
    });
  }

  void hideAllList() {
    setState(() {
      displayrecommends3 = recommends3.sublist(0, 3);
    });
  }

  Widget RCM1image(String image) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: image == null
                  ? Image.asset(
                      "assets/image/spin.gif",
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 140,
                      height: 140,
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/image/spin.gif",
                        image: image,
                        fit: BoxFit.cover,
                      ),
                    ))
        ],
      ),
    );
  }

  Widget RCM1(Recommend1 content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                KnowHowDetail(knowhowNo: content.knowhowNo)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.64,
                    child: Text(
                      content.title,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: content.profilePic == null
                          ? Image.asset(
                              "assets/image/spin.gif",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/image/spin.gif",
                                image: content.profilePic,
                                fit: BoxFit.cover,
                              ),
                            )),
                  SizedBox(width: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                    child: Text(
                      content.writer,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 600,
          height: 1,
          color: const Color(0xffDBDBDB),
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: content.imageList.map((e) => RCM1image(e)).toList() +
                  [
                    Container(
                        width: 140,
                        height: 140,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KnowHowDetail(
                                          knowhowNo: content.knowhowNo)));
                            },
                            child: const Text("글 보러가기")))
                  ]),
        ),
        Container(width: 600, height: 8, color: const Color(0xffDBDBDB)),
      ], // children
    );
  }

  Widget RCM2(Recommend2 content) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetail(itemPk: content.productNo)));
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: content.image == null
                      ? Image.asset(
                          "assets/image/spin.gif",
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 140,
                          height: 140,
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/image/spin.gif",
                            image: content.image,
                            fit: BoxFit.cover,
                          ),
                        )),
              SizedBox(height: 8),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  width: 140,
                  child: Text(
                    content.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
              SizedBox(height: 4),
              // Text(
              //   "Product Title 1",
              //   style: TextStyle(fontSize: 12),
              // ),
              SizedBox(height: 4),
              Text(
                " ${priceDot(content.price)}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                        size: 16,
                      )),
                  SizedBox(width: 4),
                  Text(content.heartCount.toString()),
                ],
              ),
            ],
          ),
        ));
  }

  Widget RCM3(Recommend3 content) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetail(itemPk: content.productNo)));
        },
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: content.image == null
                      ? Image.asset(
                          "assets/image/spin.gif",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/image/spin.gif",
                            image: content.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                )),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      content.title,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                const SizedBox(height: 8),
                // Text(
                //   "Title",
                //   style: TextStyle(fontSize: 14),
                // ),
                // const SizedBox(height: 8),
                Text(
                  "${priceDot(content.price)}",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 16),
                    const SizedBox(width: 4),
                    Text(content.heartCount.toString(),
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

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
            const Text("지금 인기있는 플리마켓 상품!\u{1f609}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text("더보기"),
            )
          ])),
      // popular goods
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: recommends2.map((e) => RCM2(e)).toList(),
        ),
      ),
      // recommended goods
      Container(
        width: 600,
        height: 12,
        color: const Color(0xffF4F2F2),
      ),
      Container(
        width: 600,
        margin: const EdgeInsets.fromLTRB(16, 4, 0, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Text(
                "리폼왕춘식이 님을 위한 추천 상품!\u{1f4d3}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      Container(
        width: 600,
        height: 1,
        color: const Color(0xffDBDBDB),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: displayrecommends3.map((e) => RCM3(e)).toList(),
      ),
      TextButton(
        onPressed: () {
          if (displayrecommends3.length == 3) {
            showAllList();
          } else {
            hideAllList();
          }
        },
        child: Text(displayrecommends3.length == 3 ? "더보기" : "접기"),
      ),

      // popular knowhow
      Container(width: 600, height: 12, color: const Color(0xffF4F2F2)),
      Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(16, 4, 0, 4),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("지금 인기있는 노하우 글!\u{1f49d}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text("더보기"),
            )
          ])),
      Container(width: 600, height: 1, color: const Color(0xffDBDBDB)),
      // 이미지 부분
      Column(
        children: recommends1.map((e) => RCM1(e)).toList(),
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
