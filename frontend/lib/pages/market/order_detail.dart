import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/services/Market.dart';

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
    return Container(child: Text('hello'));
  }
}
