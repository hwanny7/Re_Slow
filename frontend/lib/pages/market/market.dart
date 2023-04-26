import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';
import 'package:reslow/widgets/market/item_info.dart';
import 'package:reslow/models/market_item.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  List<MarketItem> itemList = [
    MarketItem(name: '청바지', price: '540원'),
    MarketItem(name: '니트', price: '700원'),
    MarketItem(name: '치마', price: '1900원'),
    MarketItem(name: '신발', price: '5200원'),
    MarketItem(name: '핸드폰', price: '500원'),
    MarketItem(name: '텀블러', price: '3500원'),
    MarketItem(name: '명품가방', price: '2500원'),
    MarketItem(name: '양말', price: '9500원'),
    MarketItem(name: '레이스', price: '1500원'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.center, child: MySearchBar()),
        const CategoryTapBar(),
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
