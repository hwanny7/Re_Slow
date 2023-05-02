import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class ItemDetail extends StatefulWidget {
  final int itemPk;

  ItemDetail({required this.itemPk});

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final DioClient dioClient = DioClient();
  MarketItemDetail? item;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchItemDetail(widget.itemPk);
  }

  void fetchItemDetail(int itemPk) async {
    Response response = await dioClient.dio.get('/products/$itemPk');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData);

      setState(() {
        item = MarketItemDetail.fromJson(jsonData);
        print(item);
      });
    } else {
      // Handle any errors or display an error message
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(backgroundColor: Colors.black.withOpacity(0.2)),
      body: item == null
          ? const Center(child: CircularProgressIndicator())
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    item!.profileImg,
                  ),
                ),
                title: Text(
                  item!.nickname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                color: Color(0xFFBDBDBD),
                thickness: 0.5,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Text(
                    item!.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(item!.date)
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  item!.description,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ]),
      bottomNavigationBar: item == null
          ? null
          : BottomAppBar(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFBDBDBD), // Set the top border color
                      width: 0.5, // Set the top border thickness
                    ),
                  ),
                ),
                height: 60.0,
                child: Row(children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xFFBDBDBD), // Set the top border color
                          width: 0.5, // Set the top border thickness
                        ),
                      ),
                    ),
                    height: 60.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isLiked
                            ? Colors.red
                            : Colors.grey, // Change color based on condition
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked; // Toggle the liked state
                        });
                      },
                    ),
                  ),
                  Text(
                    '${item!.price}원',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            ),
    ));
  }
}
