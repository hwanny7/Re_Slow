import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/item_detail.dart';
import 'package:reslow/pages/market/order_detail.dart';
import 'package:reslow/pages/profile/delivery_check.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/navigator.dart';

class BuyItemInfo extends StatefulWidget {
  final MyBuyItem item;
  final Function(int) removeItem;
  final int index;

  const BuyItemInfo(
      {Key? key,
      required this.item,
      required this.removeItem,
      required this.index})
      : super(key: key);

  @override
  _BuyItemInfoState createState() => _BuyItemInfoState();
}

class _BuyItemInfoState extends State<BuyItemInfo> {
  String date = '';
  String price = '';
  List<String> buttonText = [
    '',
    '주문 취소',
    '배송 준비 중 입니다.',
    '배송조회',
    '구매 확정',
    '거래가 완료되었습니다.'
  ];

  @override
  void initState() {
    super.initState();
    date = widget.item.date
        .substring(0, widget.item.date.length - 9)
        .replaceAll('-', '.');
    price = priceDot(widget.item.price);
  }

  void buttonHandler(int status) async {
    print(status);
    if (status case 1) {
      Response response =
          await changeStatus(widget.item.orderNo!, {"status": 6});
      if (response.statusCode == 200) {
        widget.removeItem(widget.index);
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
      return;
    } else if (status case 4) {
      Response response =
          await changeStatus(widget.item.orderNo!, {"status": 5});
      if (response.statusCode == 200) {
        setState(() {
          widget.item.status += 1;
        });
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
    }
    // else if (status case 3) {
    //   break;
    // } else if (status case 4) {
    //   break;
    // }
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
                              child: Text(widget.item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
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
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            widget.item.status == 2 || widget.item.status == 5
                                ? Colors.grey
                                : Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: Material(
                      color: widget.item.status == 3 || widget.item.status == 4
                          ? const Color(0xff3C9F61)
                          : widget.item.status == 1
                              ? const Color(0xffFFA9A9)
                              : Colors.white,
                      child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            if (widget.item.status == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeliveryCheck(
                                          tcode: widget.item.carrierCompany,
                                          tinvoice: widget.item.carrierTrack,
                                        )),
                              );
                            } else {
                              buttonHandler(widget.item.status);
                            }
                          },
                          child: Text(
                            buttonText[widget.item.status],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: widget.item.status == 2 ||
                                        widget.item.status == 5
                                    ? Colors.grey
                                    : Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    )),
              ],
            )));
  }
}
