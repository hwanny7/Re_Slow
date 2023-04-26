import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';

class ItemInfo extends StatelessWidget {
  final double mediaWidth;
  final double mediaHeight;
  final MarketItem item;

  const ItemInfo({
    required this.mediaWidth,
    required this.mediaHeight,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/image/jean.jpg",
                    width: mediaWidth * 0.3,
                    height: mediaHeight * 0.15,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    height: mediaHeight * 0.15,
                    padding: EdgeInsets.only(
                      left: mediaWidth * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaWidth * 0.05,
                            )),
                        SizedBox(height: mediaHeight * 0.01),
                        Text('도안동'),
                        Text('23.04.19'),
                        SizedBox(height: mediaHeight * 0.02),
                        Text('${item.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaWidth * 0.05,
                            )),
                      ],
                    ))
              ],
            )));
  }
}









// Row(
//           children: [
//             Container(
//                 child: Image.asset("assets/image/image 1.png"),
//                 margin: const EdgeInsets.all(8)),
//             Container(
//                 child: Image.asset("assets/image/image 2.png"),
//                 margin: const EdgeInsets.all(8)),
//             Container(
//                 child: Image.asset("assets/image/image 3.png"),
//                 margin: const EdgeInsets.all(8)),
//           ],
// )