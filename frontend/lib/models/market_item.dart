class MarketItem {
  final String name;
  final String price;

  MarketItem({
    required this.name,
    required this.price,
  });

  // factory User.fromJson(Map<String, dynamic> responseData) {
  //   return User(
  //       userId: responseData['userId'],
  //       accessToken: responseData['accessToken'],
  //       refreshToken: responseData['refreshToken']);
  // }
}


// class MyObject {
//   final int id;
//   final String name;
//   final List<String> items;

//   MyObject({required this.id, required this.name, required this.items});

//   factory MyObject.fromJson(Map<String, dynamic> json) {
//     return MyObject(
//       id: json['id'],
//       name: json['name'],
//       items: List<String>.from(json['items']),
//     );
//   }
// }