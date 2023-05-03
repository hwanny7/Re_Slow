import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:dots_indicator/dots_indicator.dart';

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
  final PageController _pageController = PageController();
  int _currentPicture = 0;

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
          : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 300,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPicture = index;
                              });
                            },
                            itemCount: item!.images.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                item!.images[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: DotsIndicator(
                              dotsCount: item!.images.length,
                              position: _currentPicture.toDouble(),
                              decorator: DotsDecorator(
                                color: Colors.grey, // Color of the dots
                                activeColor:
                                    Colors.blue, // Color of the active dot
                                size:
                                    const Size.square(9.0), // Size of the dots
                                activeSize: const Size(
                                    18.0, 9.0), // Size of the active dot
                                spacing:
                                    EdgeInsets.all(4.0), // Spacing between dots
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Shape of the active dot
                                ),
                              ),
                            ))
                      ],
                    ),
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
            ),
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
