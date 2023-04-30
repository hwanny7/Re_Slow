import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class CouponList extends StatelessWidget {
  final List<Coupon> coupons;

  CouponList({required this.coupons});

  @override
  Widget build(BuildContext context) {
    List<Coupon> coupons = [
      Coupon(discount: 50, startDate: '2023-04-01', endDate: '2023-04-30'),
      Coupon(discount: 30, startDate: '2023-05-01', endDate: '2023-05-31'),
      Coupon(discount: 20, startDate: '2023-06-01', endDate: '2023-06-30'),
      Coupon(discount: 10, startDate: '2023-07-01', endDate: '2023-07-31'),
      Coupon(discount: 15, startDate: '2023-08-01', endDate: '2023-08-31'),
      Coupon(discount: 22, startDate: '2023-04-01', endDate: '2023-04-30'),
      Coupon(discount: 11, startDate: '2023-05-01', endDate: '2023-05-31'),
      Coupon(discount: 44, startDate: '2023-06-01', endDate: '2023-06-30'),
      Coupon(discount: 22, startDate: '2023-07-01', endDate: '2023-07-31'),
      Coupon(discount: 33, startDate: '2023-08-01', endDate: '2023-08-31'),
    ];

    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: '보유 쿠폰'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (BuildContext context, int index) {
                  Coupon coupon = coupons[index];
                  return Card(
                    color: Colors.green.shade200,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: ListTile(
                        title: Text('${coupon.discount}% off'),
                        subtitle:
                            Text('${coupon.startDate} ~ ${coupon.endDate}'),
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
  final int discount;
  final String startDate;
  final String endDate;

  Coupon(
      {required this.discount, required this.startDate, required this.endDate});
}
