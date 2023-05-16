import 'package:dio/dio.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/utils/dio_client.dart';
// import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:reslow/models/coupon_model.dart';

class CouponDownload extends StatefulWidget {
  // const CouponDownload({Key? key}) : super(key: key);
  final int couponPk;

  const CouponDownload({Key? key, required this.couponPk}) : super(key: key);

  // Home({required this.couponPk});

  @override
  _CouponDownloadState createState() => _CouponDownloadState();
}

class _CouponDownloadState extends State<CouponDownload> {
  // replace <couponNo> with the actual coupon number
  // int couponNo = <couponNo>;
  final DioClient dioClient = DioClient();
  CouponDetail? coupon;
  // int couponNo = 10;
  late int couponPk;

  @override
  void initState() {
    super.initState();
    // Initialize couponPk here
    // coupon = null; // 아무것도 없는데 상세 정보 채우기
    // couponPk = widget.couponPk;
    fetchCouponDownload(widget.couponPk);
  }

  void fetchCouponDownload(int couponPk) async {
    Response response =
        await dioClient.dio.get('/coupons/$couponPk'); // 쿠폰 상세 조회
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData);

      setState(() {
        coupon = CouponDetail.fromJson(jsonData);
        print(coupon);
      });
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: EdgeInsets.all(20.0), // set the amount of padding you want
      child: coupon == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // '${priceDot(coupon!.discountAmount)}',
                          coupon!.discountType == 1
                              ? priceDot(
                                  coupon!.discountAmount) // Amount discount
                              : '${coupon!.discountPercent}% OFF', // Percent discount
                          style: TextStyle(fontSize: 48.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          coupon!.content, // set the description here
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          '사용기간 ${coupon!.startDate.substring(0, coupon!.startDate.length - 3).replaceAll('T', ' ')} ~ ${coupon!.endDate.substring(0, coupon!.startDate.length - 3).replaceAll('T', ' ')}', // set the start and end dates here
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  // 버튼
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 쿠폰 다운로드 버튼
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // 쿠폰 다운로드 버튼
                              Response response = await dioClient.dio.post(
                                  '/coupons//${coupon?.couponNo}/issuance');
                              // handle the response based on its status code
                              if (response.statusCode == 200) {
                                Map<String, dynamic> jsonData = response.data;

                                print(jsonData);
                                print('쿠폰 다운로드 완료!');
                                // show a success message or perform other actions
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('쿠폰이 발급되었습니다.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (response.statusCode == 404) {
                                print('이미 다운로드 받은 쿠폰');
                                // show a message when the coupon is already downloaded
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Coupon Already Downloaded'),
                                      content: Text(
                                          'This coupon has already been downloaded.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // dismiss the dialog
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                print('다운로드 실패');
                                print(
                                    'HTTP request failed with status: ${response.statusCode}');
                                // show an error message or perform other actions
                              }
                            },
                            icon: Icon(Icons.download),
                            label: Text('다운로드'),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 50),
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('닫기'),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 50),
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  // 버튼 끝
                ],
              ),
            ),
    )));
  }
}
