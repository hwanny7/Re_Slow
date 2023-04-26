import 'package:flutter/material.dart';
import 'notificationsetting.dart';
import 'notificationpage.dart';
import 'couponlist.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Profile
          Container(
            height: 150,
            color: Colors.grey[300],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/image/test.jpg'),
                ),
                Text(
                  '리폼왕 춘식이',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Icons
          const SizedBox(height: 20),
          Container(
            color: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(),
                          ),
                        );
                      },
                    ),
                    Text('알림'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.local_offer),
                      onPressed: () {
                        // Navigate to couponlist
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CouponList(),
                          ),
                        );
                      },
                    ),
                    Text('쿠폰'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        // Navigate to likes page
                      },
                    ),
                    Text('관심'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // konw-how-started
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Text(
              '노하우',
              style: TextStyle(fontSize: 20),
              // textAlign: TextAlign.left,
            ),
            alignment: Alignment.centerLeft,
          ),
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to my know-how post page
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                            width: 10), // for spacing between icon and text
                        Text(
                          '내가 쓴 글',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                // know-how ended
                // add Divider here
                Divider(),
                // flea market section
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    '플리마켓',
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the flea market page
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_bag),
                        SizedBox(
                            width: 10), // for spacing between icon and text
                        Text(
                          '나의 상품 리스트',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      SizedBox(width: 10), // for spacing between icon and text
                      Text(
                        '나의 구매 리스트',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 10), // for spacing between icon and text
                      Text(
                        '나의 매출 현황',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                ),
                // flee market ended
                // add Divider here
                Divider(),
                // Settings
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    '설정',
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to my account settings page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationSetting()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(
                                  width:
                                      10), // for spacing between icon and text
                              Text(
                                '알림 설정',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.shield),
                            SizedBox(
                                width: 10), // for spacing between icon and text
                            Text(
                              '개인 정보',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.warning),
                            SizedBox(
                                width: 10), // for spacing between icon and text
                            Text(
                              '신고 하기',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(
                                width: 10), // for spacing between icon and text
                            Text(
                              '로그아웃',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
