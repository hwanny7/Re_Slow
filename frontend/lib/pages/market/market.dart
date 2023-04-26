import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';

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
            return Card(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/image/jean.jpg",
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.15,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${itemList[idx]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    )),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Text('도안동'),
                                Text('23.04.19'),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                                Text('5500원',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    )),
                              ],
                            ))
                      ],
                    )));
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