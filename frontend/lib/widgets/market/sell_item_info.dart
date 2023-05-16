import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/item_detail.dart';
import 'package:reslow/pages/market/order_detail.dart';
import 'package:reslow/pages/profile/delivery_check.dart';
import 'package:reslow/pages/profile/my_Bottom_sheet.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/navigator.dart';

class SellItemInfo extends StatefulWidget {
  final MyBuyItem item;
  final Function(int, String) removeItem;
  final int index;

  const SellItemInfo(
      {Key? key,
      required this.index,
      required this.removeItem,
      required this.item})
      : super(key: key);

  @override
  _SellItemInfoState createState() => _SellItemInfoState();
}

class _SellItemInfoState extends State<SellItemInfo> {
  String date = '';
  String price = '';
  List<String> buttonText = [
    '주문 대기 중인 상품입니다.',
    '결제 완료',
    '송장번호 입력',
    '배송 조회',
    '배송이 완료된 상품입니다.',
    '구매 확정된 상품입니다.'
  ];

  @override
  void initState() {
    super.initState();
    date = widget.item.date
        .substring(0, widget.item.date.length - 9)
        .replaceAll('-', '.');
    price = priceDot(widget.item.price);
  }

  void acceptOrDeny(String choice) async {
    Response response = await changeStatus(
        widget.item.orderNo!, {"status": choice == "수락" ? 2 : 6});
    if (response.statusCode == 200) {
      widget.removeItem(widget.index, choice);
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void gotDeliveryMan(String carrierTrack, String carrierCompany) async {
    print(carrierCompany);
    print(carrierTrack);
    Response response = await InputDelivery(widget.item.orderNo!,
        {"carrierTrack": carrierTrack, "carrierCompany": carrierCompany});
    if (response.statusCode == 200) {
      print("성공");
      widget.removeItem(widget.index, "변경");
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Spacer(),
                    if (widget.item.orderNo != null)
                      ElevatedButton(
                          onPressed: () {
                            leftToRightNavigator(
                                OrderDetail(
                                  orderPk: widget.item.orderNo ?? 0,
                                ),
                                context);
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 10.0),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                color: Colors.green,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.description, color: Colors.green),
                              Text('주문내역'),
                            ],
                          ))
                  ],
                ),
                const Divider(
                  color: Color(0xFFBDBDBD),
                  thickness: 0.5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: Image.network(
                        widget.item.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                leftToRightNavigator(
                                    ItemDetail(itemPk: widget.item.productNo),
                                    context);
                              },
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(widget.item.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ))),
                            ),
                            const SizedBox(height: 8),
                            Text(price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ))
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 16),
                widget.item.status == 1
                    ? Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  acceptOrDeny("거절");
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                ),
                                child: const Text(
                                  '주문 거절',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  acceptOrDeny("수락");
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xff3C9F61)),
                                ),
                                child: const Text(
                                  '주문 수락',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Material(
                          color: widget.item.status == 1 ||
                                  widget.item.status == 2 ||
                                  widget.item.status == 3
                              ? const Color(0xff3C9F61)
                              : Colors.white,
                          child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                if (widget.item.status == 2) {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MyBottomSheet(
                                            gotDeliveryMan: gotDeliveryMan);
                                      });
                                } else if (widget.item.status == 3) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DeliveryCheck(
                                              tcode: widget.item.carrierCompany,
                                              tinvoice:
                                                  widget.item.carrierTrack,
                                            )),
                                  );
                                }
                              },
                              child: Text(
                                buttonText[widget.item.status],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: widget.item.status == 1 ||
                                            widget.item.status == 2 ||
                                            widget.item.status == 3
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold),
                              )),
                        )),
              ],
            )));
  }
}
