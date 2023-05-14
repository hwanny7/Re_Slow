import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/cupon_list.dart';
import 'package:reslow/pages/market/payment.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:kpostal/kpostal.dart';

class BuyItem extends StatefulWidget {
  final MarketItemDetail? item;

  const BuyItem({Key? key, this.item}) : super(key: key);

  @override
  _BuyItemState createState() => _BuyItemState();
}

class _BuyItemState extends State<BuyItem> {
  String zipcode = '-';
  String roadAddress = '-';
  String price = '';
  String deliveryFee = '';
  int intPrice = 0;
  String totalPrice = '';
  String recipient = '';
  String phoneNumber = '';
  String memo = '';
  String addressDetail = '';
  int? issuedCouponNo;

  @override
  void initState() {
    price = priceDot(widget.item!.price);
    deliveryFee = priceDot(widget.item!.deliveryFee);
    intPrice = widget.item!.price + widget.item!.deliveryFee;
    totalPrice = priceDot(intPrice);
    fetchData();
    super.initState();
  }

  void fetchData() async {
    print('Hello');
    Response response = await getMyCupons();
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData["content"]);
      // setState(() {
      //   order = GetOrder.fromJson(jsonData);
      // });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "구매하기"),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    recipient = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: '수령인',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: '연락처',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 265,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        enabled: false,
                        hintText: zipcode == '-' ? '우편번호' : zipcode,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff3C9F61)),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              // useLocalServer: false,
                              // localPort: 8080,
                              // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                              callback: (Kpostal result) {
                                setState(() {
                                  zipcode = result.postCode;
                                  roadAddress = result.address;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('주소 검색',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3C9F61),
                            fontSize: 13,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: roadAddress == '-' ? '주소' : roadAddress,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    addressDetail = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: '상세주소',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    memo = value;
                  });
                },
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: '요청사항',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 21, // 65% width
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: '쿠폰 할인',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 6, // 30% width
                        child: Container(
                          margin: const EdgeInsets.only(left: 11, bottom: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xff3C9F61)),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.0, 1.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const CuponList();
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                            ),
                            child: const Text('사용',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3C9F61),
                                  fontSize: 13,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color(0xFFBDBDBD),
                    thickness: 0.5,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        widget.item!.images[0],
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        widget.item!.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Divider(
                    color: Color(0xFFBDBDBD),
                    thickness: 0.5,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Text(
                        '물품 가격',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        price,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      const Text(
                        '배송비',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        deliveryFee,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color(0xFFBDBDBD),
                    thickness: 0.5,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Text(
                        '결제 금액',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        totalPrice,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFF165B40),
                    child: MaterialButton(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () {
                          OrderingInformation orderingInformation =
                              OrderingInformation(
                                  recipient: recipient,
                                  zipcode: int.parse(zipcode),
                                  address: roadAddress,
                                  addressDetail: addressDetail,
                                  phoneNumber: phoneNumber,
                                  memo: memo,
                                  issuedCouponNo: issuedCouponNo,
                                  productNo: widget.item!.productNo);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Payment(
                                    totalPrice: intPrice,
                                    orderingInformation: orderingInformation)),
                          );
                        },
                        child: const Text(
                          "구매하기",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
