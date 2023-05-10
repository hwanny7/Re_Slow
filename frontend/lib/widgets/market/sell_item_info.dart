import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/order_detail.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/navigator.dart';

class SellItemInfo extends StatefulWidget {
  final MyBuyItem item;

  const SellItemInfo({Key? key, required this.item}) : super(key: key);

  @override
  _SellItemInfoState createState() => _SellItemInfoState();
}

class _SellItemInfoState extends State<SellItemInfo> {
  String date = '';
  String price = '';
  List<String> buttonText = ['판매 중', '결제완료', '배송 준비 중', '배송 중', '배송완료', '구매확정'];

  @override
  void initState() {
    super.initState();
    date = widget.item.date
        .substring(0, widget.item.date.length - 9)
        .replaceAll('-', '.');
    price = priceDot(widget.item.price);
  }

  void buttonHandler(int status) {
    switch (status) {
      case 1:
        // Do something for case 0
        break;
      case 2:
        // Do something for case 1
        break;
      case 3:
        // Do something for case 2
        break;
      case 4:
        // Do something for case 2
        break;
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
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
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Material(
                      color: Colors.white,
                      child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            buttonHandler(widget.item.status);
                          },
                          child: Text(
                            buttonText[widget.item.status],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    )),
              ],
            )));
  }
}
