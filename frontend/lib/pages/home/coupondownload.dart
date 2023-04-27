import 'package:flutter/material.dart';

class CouponDownload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupon Download'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '10%', // set the discount percentage here
              style: TextStyle(fontSize: 48.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Get 10% off on your next purchase of any product!', // set the description here
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Valid from 2023-05-01 to 2023-05-31', // set the start and end dates here
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download),
                  label: Text('Download'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Exit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
