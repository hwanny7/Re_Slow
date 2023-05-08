import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '50%', // set the discount percentage here
                    style: TextStyle(fontSize: 48.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '모든 상품에 적용 가능', // set the description here
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '사용기간 2023-05-01 ~ 2023-05-31', // set the start and end dates here
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
                        // API 완성되면 DIO 로 연결
                        // // make the API call
                        // final response = await http.post(
                        //   Uri.parse(
                        //       'http://k8b306.p.ssafy.io:8080/coupons/${coupon?.couponNo}/issuance'),
                        // );
                        Response response = await dioClient.dio
                            .post('/coupons//${coupon?.couponNo}/issuance');

                        // handle the response based on its status code
                        if (response.statusCode == 200) {
                          Map<String, dynamic> jsonData = response.data;
                          print(jsonData);
                          // show a success message or perform other actions
                        } else {
                          print(
                              'HTTP request failed with status: ${response.statusCode}');
                          // show an error message or perform other actions
                        }
                      },
                      icon: Icon(Icons.download),
                      label: Text('다운로드'),
                      style: ElevatedButton.styleFrom(
                        // adjust the height of the ElevatedButton
                        fixedSize: Size(200, 50),

                        // change the background color of the ElevatedButton
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
                        // adjust the height of the ElevatedButton
                        fixedSize: Size(200, 50),

                        // change the background color of the ElevatedButton
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
    ));
  }
}
