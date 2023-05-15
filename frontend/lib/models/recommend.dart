class Recommend1 {
  final String title;
  final int knowhowNo;
  final String writer;
  final String profilePic;
  final List<String> imageList;

  Recommend1(
      {required this.title,
      required this.knowhowNo,
      required this.writer,
      required this.imageList,
      required this.profilePic});

  factory Recommend1.fromJson(Map<String, dynamic> json) {
    return Recommend1(
      title: json['title'],
      knowhowNo: json['knowhowNo'],
      writer: json['writer'],
      profilePic: json['profilePic'],
      imageList: List<String>.from(json['imageList']),
    );
  }
}

class Recommend2 {
  final int productNo;
  final String title;
  final int price;
  final String image;
  final int heartCount;

  Recommend2({
    required this.productNo,
    required this.title,
    required this.price,
    required this.image,
    required this.heartCount,
  });

  factory Recommend2.fromJson(Map<String, dynamic> json) {
    return Recommend2(
        productNo: json['productNo'],
        title: json['title'],
        price: json['price'],
        image: json['image'],
        heartCount: json['heartCount']);
  }
}

class Recommend3 {
  final int productNo;
  final String title;
  final int price;
  final String image;
  final int heartCount;

  Recommend3({
    required this.productNo,
    required this.title,
    required this.price,
    required this.image,
    required this.heartCount,
  });

  factory Recommend3.fromJson(Map<String, dynamic> json) {
    return Recommend3(
      productNo: json['productNo'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      heartCount: json['heartCount'],
    );
  }
}
