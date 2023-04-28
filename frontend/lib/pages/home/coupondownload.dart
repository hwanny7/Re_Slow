import 'package:flutter/material.dart';

class CouponDownload extends StatelessWidget {
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
              child: Column(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
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
