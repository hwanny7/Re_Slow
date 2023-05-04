import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';
import 'package:reslow/widgets/market/item_info.dart';
import 'package:reslow/models/market_item.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  List<MarketItem> itemList = [];
  final DioClient dioClient = DioClient();
  int category = 0;
  String searchText = "";

  void _getCategory(int index) {
    category = index;
    fetchData();
  }

  void _getSearchText(String text) {
    searchText = text;
    fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Perform the HTTP GET request here
    // For example, using the http package
    Map<String, dynamic> queryParams = {
      'page': 0,
      'size': 10,
      'category': category == 0 ? '' : category,
      'keyword': searchText,
    };
    Response response =
        await dioClient.dio.get('/products', queryParameters: queryParams);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = {"content": response.data};
      // print(jsonData);

      setState(() {
        // Update the state with the fetched data
        itemList = List<MarketItem>.from(jsonData['content']
            .map((itemJson) => MarketItem.fromJson(itemJson)));
      });
    } else {
      // Handle any errors or display an error message
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.center,
            child: MySearchBar(searchcallback: _getSearchText)),
        CategoryTapBar(
          callback: _getCategory,
          initNumber: category,
        ),
        Expanded(
            child: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, idx) {
            return ItemInfo(
              mediaWidth: MediaQuery.of(context).size.width,
              mediaHeight: MediaQuery.of(context).size.height,
              item: itemList[idx],
            );
          },
        )),
      ],
    );
  }
}
