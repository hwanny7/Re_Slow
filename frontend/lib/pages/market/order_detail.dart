import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/profile/delivery_check.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class OrderDetail extends StatefulWidget {
  final int orderPk;
  const OrderDetail({Key? key, required this.orderPk}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  GetOrder? order;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    Response response = await getOrder(widget.orderPk);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData);
      setState(() {
        order = GetOrder.fromJson(jsonData);
      });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(title: '주문 상세내역'),
            body: order == null
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                  'No. ${order!.date.replaceAll(RegExp(r'[^\d]'), '')}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(
                                  order!.date
                                      .substring(0, order!.date.length - 3)
                                      .replaceAll('-', '.')
                                      .replaceAll('T', ' '),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(
                            color: Color(0xFFBDBDBD),
                            thickness: 0.5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 150.0,
                                width: 150.0,
                                child: Image.network(
                                  order!.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.49,
                                        child: Text(order!.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ))),
                                    const SizedBox(height: 15),
                                    Container(
                                        width: 180,
                                        height: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('주문 금액',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const Spacer(),
                                                Text(
                                                    priceDot(order!.totalPrice),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[800],
                                            ),
                                            Row(
                                              children: [
                                                Text('상품 금액',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                const Spacer(),
                                                Text(
                                                    priceDot(
                                                        order!.productPrice),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blue[500]))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('배송 금액',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                const Spacer(),
                                                Text(
                                                    '+ ${priceDot(order!.deliveryFee)}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blue[500]))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('쿠폰 할인',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const Spacer(),
                                                Text(
                                                    '- ${priceDot(order!.discountPrice)}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blue[500]))
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 29,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: Material(
                                color: Colors.white,
                                child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DeliveryCheck(
                                                  tcode: order!.carrierCompany,
                                                  tinvoice: order!.carrierTrack,
                                                )),
                                      );
                                    },
                                    child: const Text(
                                      "배송 조회",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )),
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(
                            color: Color(0xFFBDBDBD),
                            thickness: 0.5,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            '배송지정보',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Text('받으시는 분',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(order!.recipient,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Text('연락처',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(order!.phoneNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Text('배송지',
                                  overflow: TextOverflow
                                      .ellipsis, // Display "..." at the end if the text overflows
                                  maxLines: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                      '(${order!.zipcode}) ${order!.address} ${order!.addressDetail}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)))
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              const Text('요청사항',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(order!.memo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ],
                      ),
                    ),
                  )));
  }
}
