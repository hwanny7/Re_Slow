import 'package:reslow/utils/date.dart';

class MarketItem {
  final int productNo;
  final String title;
  final String price;
  final String datetime;
  final String image;

  MarketItem({
    required this.productNo,
    required this.title,
    required this.price,
    required this.datetime,
    required this.image,
  });

  factory MarketItem.fromJson(Map<String, dynamic> responseData) {
    return MarketItem(
        productNo: responseData['productNo'],
        title: responseData['title'],
        price: priceDot(responseData['price']),
        datetime: responseData['datetime'],
        image: responseData['image']);
  }
}

class MarketItemDetail {
  final List<dynamic> images;
  final String title;
  final String description;
  final int deliveryFee;
  final String price;
  final String category;
  final String date;
  final bool mine;
  final String nickname;
  final String profileImg;
  int heartCount;
  bool myHeart;

  MarketItemDetail({
    required this.images,
    required this.title,
    required this.description,
    required this.deliveryFee,
    required this.price,
    required this.category,
    required this.date,
    required this.mine,
    required this.nickname,
    required this.profileImg,
    required this.heartCount,
    required this.myHeart,
  });

  factory MarketItemDetail.fromJson(Map<String, dynamic> responseData) {
    return MarketItemDetail(
        images: responseData['images'],
        title: responseData['title'],
        price: priceDot(responseData['price']),
        myHeart: responseData['myHeart'],
        heartCount: responseData['heartCount'],
        date: formatTimeDifference(responseData['date']),
        deliveryFee: responseData['deliveryFee'],
        category: responseData['category'],
        mine: responseData['mine'],
        nickname: responseData['nickname'],
        profileImg: responseData['profileImg'],
        description: responseData['description']);
  }
}
