import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/coupon_model.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/pages/market/cupon_list.dart';
import 'package:reslow/pages/market/payment.dart';
import 'package:reslow/services/auth_modify.dart';
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
  Shipment shipment = Shipment();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  final TextEditingController _memoDetailController = TextEditingController();
  Shipment registeredShipment = Shipment();

  String price = '';
  int intPrice = 0;
  String deliveryFee = '';
  int? issuedCouponNo;
  MyCoupons? coupon;
  int couponPrice = 0;

  bool? _isChecked = false;

  @override
  void initState() {
    super.initState();
    price = priceDot(widget.item!.price);
    deliveryFee = priceDot(widget.item!.deliveryFee);
    intPrice = widget.item!.price + widget.item!.deliveryFee;
    fetchData();
  }

  void fetchData() async {
    Response response = await getShipmentInfo();
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      setState(() {
        registeredShipment = Shipment.fromJson(jsonData);
      });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void setCoupon(MyCoupons newCoupon) {
    setState(() {
      coupon = newCoupon;
      if (coupon?.discountType != 1) {
        coupon?.discountAmount =
            (widget.item!.price * coupon!.discountPercent ~/ 100);
      }
      intPrice = intPrice < coupon!.discountAmount
          ? 0
          : (intPrice - coupon!.discountAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "구매하기"),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  '기본 배송지와 동일',
                  textAlign: TextAlign.end,
                ),
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value;
                      if (_isChecked!) {
                        shipment = registeredShipment;
                        _recipientController.text = shipment.recipient;
                        _phoneNumberController.text = shipment.phoneNumber;
                        _addressDetailController.text = shipment.addressDetail;
                        _memoDetailController.text = shipment.memo;
                      } else {
                        shipment = Shipment();
                        _recipientController.text = '';
                        _phoneNumberController.text = '';
                        _addressDetailController.text = '';
                        _memoDetailController.text = '';
                      }
                    });
                  },
                ),
              ],
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
                    shipment.recipient = value;
                  });
                },
                controller: _recipientController,
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
                    shipment.phoneNumber = value;
                  });
                },
                controller: _phoneNumberController,
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
                        hintText:
                            shipment.zipcode == "" ? '우편번호' : shipment.zipcode,
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
                                  shipment.zipcode = result.postCode;
                                  shipment.address = result.address;
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
                  hintText: shipment.address == "" ? '주소' : shipment.address,
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
                    shipment.addressDetail = value;
                  });
                },
                controller: _addressDetailController,
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
                    shipment.memo = value;
                  });
                },
                controller: _memoDetailController,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: '요청사항 (선택사항)',
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
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: coupon == null ? '쿠폰 할인' : coupon?.name,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16.0),
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
                                    return CuponList(setCoupon: setCoupon);
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
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(widget.item!.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ))),
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
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      const Text(
                        '쿠폰 할인',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        coupon?.discountAmount == null
                            ? "- 0원"
                            : "- ${priceDot(coupon?.discountAmount)}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
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
                        priceDot(intPrice),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ],
        )),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  onPressed: shipment.address.isNotEmpty &&
                          shipment.addressDetail.isNotEmpty &&
                          shipment.phoneNumber.isNotEmpty &&
                          shipment.recipient.isNotEmpty &&
                          shipment.zipcode.isNotEmpty
                      ? () {
                          OrderingInformation orderingInformation =
                              OrderingInformation(
                                  recipient: shipment.recipient,
                                  zipcode: int.parse(shipment.zipcode),
                                  address: shipment.address,
                                  addressDetail: shipment.addressDetail,
                                  phoneNumber: shipment.phoneNumber,
                                  memo: shipment.memo,
                                  issuedCouponNo: coupon?.issuedCouponNo,
                                  productNo: widget.item!.productNo);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Payment(
                                    totalPrice: intPrice,
                                    orderingInformation: orderingInformation)),
                          );
                        }
                      : null,
                  child: const Text(
                    "구매하기",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            )));
  }
}
