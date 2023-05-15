import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/item_detail.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/navigator.dart';

class ItemInfo extends StatelessWidget {
  final double mediaWidth;
  final double mediaHeight;
  final MarketItem item;

  const ItemInfo({
    Key? key,
    required this.item,
    required this.mediaWidth,
    required this.mediaHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
            color: Colors.white,
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.image == null
                                ? Image.asset(
                                    "assets/image/spin.gif",
                                    width: mediaWidth * 0.3,
                                    height: mediaHeight * 0.15,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: mediaWidth * 0.3,
                                    height: mediaHeight * 0.15,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/image/spin.gif",
                                      image: item.image,
                                      fit: BoxFit.cover,
                                    ))),
                        Container(
                            height: mediaHeight * 0.15,
                            padding: EdgeInsets.only(
                              left: mediaWidth * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(item.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: mediaWidth * 0.05,
                                        ))),
                                SizedBox(height: mediaHeight * 0.01),
                                SizedBox(height: mediaHeight * 0.04),
                                Text(formatTimeDifference(item.datetime)),
                                Text(item.price,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaWidth * 0.05,
                                    )),
                              ],
                            ))
                      ],
                    )),
                Positioned(
                  bottom: 30.0,
                  right: 10.0,
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border),
                      const SizedBox(width: 5),
                      Text('${item.likeCount}'),
                    ],
                  ),
                ),
              ],
            )),
        onTap: () {
          leftToRightNavigator(ItemDetail(itemPk: item.productNo), context);
        });
  }
}
