import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:reslow/models/coupon_model.dart';

class Couponlist extends StatefulWidget {
  @override
  _CouponlistState createState() => _CouponlistState();
}

class _CouponlistState extends State<Couponlist> {
  final DioClient dioClient = DioClient();
  List<MyCoupons> coupons = [];
  bool loading = true;

  Future<void> fetchData() async {
    Map<String, dynamic> queryParams = {
      'page': 0,
      'size': 10,
      'sort': 'createdDate,desc',
    };

    Response response =
        await dioClient.dio.get('/coupons/my', queryParameters: queryParams);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;

      setState(() {
        loading = false;
        coupons = List<MyCoupons>.from(
            jsonData["content"].map((coupon) => MyCoupons.fromJson(coupon)));
      });
    } else {
      // Handle any errors or display an error message
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: '보유 쿠폰'),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : coupons.isEmpty
              ? const Center(child: Text("보유한 쿠폰이 없습니다."))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: ListView.builder(
                          itemCount: coupons.length,
                          itemBuilder: (BuildContext context, int index) {
                            MyCoupons coupon = coupons[index];
                            return Card(
                              color: Colors.green.shade200,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      coupon!.discountType == 1
                                          ? priceDot(coupon
                                              .discountAmount!) // Amount discount
                                          : '${coupon!.discountPercent}% OFF', // Percent discount
                                      style: TextStyle(
                                          fontSize: 40.0, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      coupon.name!, // set the description here
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      '사용기간 ${coupon.startDate!.substring(0, coupon!.startDate!.length - 3).replaceAll('T', ' ')} ~ ${coupon!.endDate!.substring(0, coupon!.startDate!.length - 3).replaceAll('T', ' ')}', // set the start and end dates here
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    ));
  }
}

class Coupon {
  final int couponNo;
  final String name;
  final String content;
  final int discountType;
  final int discountAmount;
  final int discountPercent;
  final int minimumOrderAmount;
  final int totalQuantity;
  final String startDate;
  final String endDate;

  Coupon({
    required this.couponNo,
    required this.name,
    required this.content,
    required this.discountType,
    required this.discountAmount,
    required this.discountPercent,
    required this.minimumOrderAmount,
    required this.totalQuantity,
    required this.startDate,
    required this.endDate,
  });

  factory Coupon.fromJson(Map<String, dynamic> responseData) {
    return Coupon(
        couponNo: responseData['couponNo'],
        name: responseData['name'],
        content: responseData['startDate'],
        discountType: responseData['discountType'],
        discountAmount: responseData['discountAmount'],
        discountPercent: responseData['discountPercent'],
        minimumOrderAmount: responseData['minimumOrderAmount'],
        totalQuantity: responseData['totalQuantity'],
        startDate: responseData['startDate'],
        endDate: responseData['endDate']);
  }
}
