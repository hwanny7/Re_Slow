import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';
import 'package:reslow/widgets/market/item_info.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  List itemList = [
    '청바지',
    '니트',
    '치마',
    '신발',
    '핸드폰 케이스',
    '텀블러',
    '명품가방',
    '양말',
    '레이스',
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
                text: itemList[idx]);
          },
        )),
      ],
    );
  }
}


// SizedBox(
//                 height: 100,
//                 child: ListTile(
//                     title: Text(itemList[idx]),
//                     subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('도안동'),
//                           Text('23.04.19'),
//                           Text('5500원'),
//                         ]),
//                     // leading: Image.asset("assets/image/image 1.png"),
//                     leading: Image(
//                       image: AssetImage("assets/image/image 1.png"),
//                       width:
//                           100, // set the width of the imaget the height of the image
//                       height: 150,
//                       // fit: BoxFit.cover, // set the fit of the image
//                     )));