import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/order_detail.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/navigator.dart';

class BuyItemInfo extends StatefulWidget {
  final MyBuyItem item;

  const BuyItemInfo({Key? key, required this.item}) : super(key: key);

  @override
  _BuyItemInfoState createState() => _BuyItemInfoState();
}

class _BuyItemInfoState extends State<BuyItemInfo> {
  String date = '';
  String price = '';
  List<String> buttonText = ['주문취소', '', '배송조회', '구매확정', '거래완료'];

  @override
  void initState() {
    super.initState();
    date = widget.item.date
        .substring(0, widget.item.date.length - 9)
        .replaceAll('-', '.');
    price = priceDot(widget.item.price);
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
                    ElevatedButton(
                        onPressed: () {
                          leftToRightNavigator(
                              OrderDetail(
                                orderPk: widget.item.orderNo,
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
                          onPressed: () {},
                          child: Text(
                            buttonText[widget.item.status - 1],
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
