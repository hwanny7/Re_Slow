import 'package:reslow/utils/date.dart';

class MarketItem {
  final int productNo;
  final String title;
  final String price;
  final String datetime;
  final String image;
  final int likeCount;

  MarketItem({
    required this.productNo,
    required this.title,
    required this.price,
    required this.datetime,
    required this.image,
    required this.likeCount,
  });

  factory MarketItem.fromJson(Map<String, dynamic> responseData) {
    return MarketItem(
        productNo: responseData['productNo'],
        likeCount: responseData['likeCount'],
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
  final int price;
  final String category;
  final String date;
  final bool mine;
  final String nickname;
  final String profileImg;
  final int productNo;
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
    required this.productNo,
  });

  factory MarketItemDetail.fromJson(Map<String, dynamic> responseData) {
    return MarketItemDetail(
        images: responseData['images'],
        title: responseData['title'],
        price: responseData['price'],
        myHeart: responseData['myHeart'],
        heartCount: responseData['heartCount'],
        date: formatTimeDifference(responseData['date']),
        deliveryFee: responseData['deliveryFee'],
        category: responseData['category'],
        mine: responseData['mine'],
        nickname: responseData['nickname'],
        profileImg: responseData['profileImg'],
        productNo: responseData['productNo'],
        description: responseData['description']);
  }
}

class OrderingInformation {
  final int? productNo;
  final String recipient;
  final int zipcode;
  final String address;
  final String addressDetail;
  final String phoneNumber;
  final String memo;
  final int? issuedCouponNo;

  OrderingInformation(
      {this.productNo,
      required this.recipient,
      required this.zipcode,
      required this.address,
      required this.addressDetail,
      required this.phoneNumber,
      required this.memo,
      this.issuedCouponNo});

  Map<String, dynamic> toJson() => {
        'productNo': productNo,
        'recipient': recipient,
        'zipcode': zipcode,
        'address': address,
        'addressDetail': addressDetail,
        'phoneNumber': phoneNumber,
        'memo': memo,
        'issuedCouponNo': issuedCouponNo,
      };
}

class GetOrder {
  final String title;
  final String date;
  final String recipient;
  final int zipcode;
  final String address;
  final String addressDetail;
  final String phoneNumber;
  final String memo;
  final int deliveryFee;
  final int discountPrice;
  final int productPrice;
  final int totalPrice;
  final String image;

  GetOrder({
    required this.title,
    required this.date,
    required this.recipient,
    required this.zipcode,
    required this.address,
    required this.addressDetail,
    required this.phoneNumber,
    required this.memo,
    required this.deliveryFee,
    required this.discountPrice,
    required this.productPrice,
    required this.totalPrice,
    required this.image,
  });

  factory GetOrder.fromJson(Map<String, dynamic> responseData) {
    return GetOrder(
      title: responseData['title'],
      date: responseData['date'],
      recipient: responseData['recipient'],
      zipcode: responseData['zipcode'],
      address: responseData['address'],
      addressDetail: responseData['addressDetail'],
      deliveryFee: responseData['deliveryFee'],
      phoneNumber: responseData['phoneNumber'],
      memo: responseData['memo'],
      discountPrice: responseData['discountPrice'],
      productPrice: responseData['productPrice'],
      totalPrice: responseData['totalPrice'],
      image: responseData['image'],
    );
  }
}

class MyBuyItem {
  final int? orderNo;
  final int productNo;
  final String title;
  final int price;
  final String date;
  final String image;
  int status;

  MyBuyItem({
    this.orderNo,
    required this.productNo,
    required this.price,
    required this.title,
    required this.date,
    required this.image,
    required this.status,
  });

  factory MyBuyItem.fromJson(Map<String, dynamic> responseData) {
    return MyBuyItem(
        productNo: responseData['productNo'],
        title: responseData['title'],
        price: responseData['price'],
        orderNo: responseData['orderNo'],
        image: responseData['image'],
        date: responseData['date'],
        status: responseData['status']);
  }
}
