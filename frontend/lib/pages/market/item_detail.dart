import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class ItemDetail extends StatefulWidget {
  final int itemPk;
  final MarketItemDetail? item;

  ItemDetail({required this.itemPk, this.item});

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final DioClient dioClient = DioClient();

  @override
  void initState() {
    super.initState();
    fetchItemDetail(widget.itemPk);
  }

  void fetchItemDetail(int itemPk) async {
    Response response = await dioClient.dio.get('/products/$itemPk');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData);

      setState(() {
        MarketItemDetail item = MarketItemDetail.fromJson(jsonData);
        print(item);
      });
    } else {
      // Handle any errors or display an error message
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('itemPk'),
    );
  }
}
