import 'package:flutter/material.dart';
import 'package:reslow/pages/profile/my_buy_list.dart';
import 'package:reslow/pages/profile/my_sell_list.dart';
import 'package:reslow/pages/profile/myknowhow.dart';
import 'package:reslow/pages/profile/mylikeknowhow.dart';
import 'package:reslow/pages/profile/user_info.dart';
import 'package:reslow/utils/navigator.dart';

import 'package:reslow/utils/shared_preference.dart';
import 'notificationsetting.dart';
import 'notificationpage.dart';
import 'couponlist.dart';
import 'package:reslow/pages/home/recommend.dart';
import 'calendarselection.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

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
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/image/test.jpg'),
                    )),
                Text(
                  '리폼왕 춘식이',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    leftToRightNavigator(const UserInfo(), context);
                  },
                ),
              ],
            ),
          ),
          Container(
            width: 600,
            height: 1,
            color: const Color(0xffDBDBDB),
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          ),
          // Icons
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xff3C9F61)),
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                        '알림',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.local_offer,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Navigate to couponlist
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Couponlist(),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text('쿠폰',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Navigate to likes page 잠시 추천 페이지로 사용
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Recommend(),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text('관심',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    )
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyKnowhow()),
                    );
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
                GestureDetector(
                  onTap: () {
                    // Navigate to my know-how post page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Mylikeknowhow()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(
                            width: 10), // for spacing between icon and text
                        Text(
                          '내가 찜한 글',
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
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    '플리마켓',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MySellList(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_bag),
                        SizedBox(
                            width: 10), // for spacing between icon and text
                        Text(
                          '판매 현황',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the CalendarSelection page when the icon is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyBuyList(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_cart),
                        SizedBox(
                            width: 10), // for spacing between icon and text
                        Text(
                          '구매 현황',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),

                // 정산 컨테이너
                GestureDetector(
                  onTap: () {
                    // Navigate to the CalendarSelection page when the icon is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarSelection(
                          onDateRangeSelected: (startDate, endDate) {
                            // Handle the date range selection here
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money),
                        SizedBox(width: 10),
                        Text(
                          '정산 현황',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),

                Divider(),
                // Settings
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    '설정',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                // Menues of Settings
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to my account settings page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NotificationSetting()), //알림설정 페이지로 이동
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
                                '알림설정',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      // 알림설정 끝
                      GestureDetector(
                        onTap: () {
                          // Navigate to privacy settings page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationSetting(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Icon(Icons.shield),
                              SizedBox(
                                width: 10,
                              ), // for spacing between icon and text
                              Text(
                                '개인정보',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      // 개인정보 끝
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Icon(Icons.warning),
                              SizedBox(
                                width: 10,
                              ), // for spacing between icon and text
                              Text(
                                '신고하기',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      // 신고하기 끝
                      GestureDetector(
                          onTap: () {
                            // Navigate to privacy settings page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NotificationSetting(), // 로그아웃 시키고 로그인 창으로 이동
                              ),
                            );
                          },
                          child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.centerLeft,
                                child: const Row(
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(
                                      width: 10,
                                    ), // for spacing between icon and text
                                    Text(
                                      '로그아웃',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                UserPreferences()
                                    .removeUser(context)
                                    .then((res) {
                                  if (res) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      '/login',
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                });
                              })),
                      // 로그아웃 끝
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
