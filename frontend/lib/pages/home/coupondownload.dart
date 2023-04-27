import 'package:flutter/material.dart';

class CouponDownload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '50%', // set the discount percentage here
              style: TextStyle(fontSize: 48.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              '모든 상품에 적용 가능', // set the description here
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              '사용기간 2023-05-01 ~ 2023-05-31', // set the start and end dates here
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50.0),
            // 버튼
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.download),
                      label: Text('다운로드'),
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
                    ),
                  ),
                ),
              ],
            ),
            // 버튼 끝
          ],
        ),
      ),
    );
  }
}
