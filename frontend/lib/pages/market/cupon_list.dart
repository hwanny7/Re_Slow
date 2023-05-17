import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/coupon_model.dart';
import 'package:reslow/services/Market.dart';
import 'package:reslow/utils/date.dart';

class CuponList extends StatefulWidget {
  final void Function(MyCoupons newCoupon)? setCoupon;
  const CuponList({Key? key, this.setCoupon}) : super(key: key);

  @override
  _CuponListState createState() => _CuponListState();
}

class _CuponListState extends State<CuponList> {
  List<MyCoupons> couponList = [];
  bool isLoading = false;
  bool isLast = false;
  bool isFirst = true;
  int page = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    Map<String, dynamic> queryParams = {
      'page': page,
      'size': 6,
    };
    Response response = await getMyCupons(queryParams);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      if (jsonData["content"].isEmpty) {
        isLast = true;
        print("empty");
      } else {
        setState(() {
          isFirst = false;
          couponList = List<MyCoupons>.from(
              jsonData["content"].map((coupon) => MyCoupons.fromJson(coupon)));
        });
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLast &&
        !isLoading) {
      isLoading = true;
      page += 1;
      await fetchData();
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            '쿠폰',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: isFirst
            ? Center(child: CircularProgressIndicator())
            : couponList.isEmpty
                ? const Center(child: Text("등록된 쿠폰이 없습니다."))
                : Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: couponList.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      height: 150,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            couponList[index].name ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            // couponList[index].startDate ?? '',
                                            '${couponList[index].startDate?.substring(0, couponList[index].startDate!.length - 3).replaceAll('T', ' ')} ~ ${couponList[index].startDate?.substring(0, couponList[index].startDate!.length - 3).replaceAll('T', ' ')}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Text(
                                            // '${priceDot(coupon!.discountAmount)}',
                                            couponList[index].discountType == 1
                                                ? priceDot(couponList[index]
                                                    .discountAmount!) // Amount discount
                                                : '${couponList[index].discountPercent}% OFF', // Percent discount
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Positioned(
                                    bottom: 25.0,
                                    right: 16.0,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        widget.setCoupon!(couponList[index]);
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.grey),
                                        elevation: 0,
                                      ),
                                      child: const Text('적용하기'),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    )));
  }
}
