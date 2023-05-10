import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:reslow/models/market_item.dart';
import 'package:reslow/pages/market/order_detail.dart';
import 'package:reslow/services/Market.dart';

class Payment extends StatelessWidget {
  final int totalPrice;
  final OrderingInformation orderingInformation;

  const Payment(
      {Key? key, required this.totalPrice, required this.orderingInformation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: AppBar(
        title: const Text('아임포트 결제'),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset('assets/images/iamport-logo.png'),
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'imp76010172',
      /* [필수입력] 결제 데이터 */
      data: PaymentData(
        pg: 'inicis', // PG사
        payMethod: 'card', // 결제수단
        name: '리슬로우', // 주문명
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        amount: totalPrice, // 결제금액
        buyerName: orderingInformation.recipient, // 구매자 이름
        buyerTel: orderingInformation.phoneNumber, // 구매자 연락처
        buyerEmail: 'example@naver.com', // 구매자 이메일
        buyerAddr: orderingInformation.address, // 구매자 주소
        buyerPostcode: '$orderingInformation.zipcode', // 구매자 우편번호
        appScheme: 'example', // 앱 URL scheme
        // cardQuota: [2, 3] //결제창 UI 내 할부개월수 제한
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) async {
        if (result['imp_success'] == 'true') {
          Response response = await createOrder(
              result['imp_uid'], orderingInformation.toJson());
          if (response.statusCode == 200) {
            Map<String, dynamic> jsonData = response.data;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetail(
                        orderPk: jsonData['orderNo'],
                      )),
            );
          } else {
            print('HTTP request failed with status: ${response.statusCode}');
            Navigator.pop(context);
          }
        }
      },
    );
  }
}
