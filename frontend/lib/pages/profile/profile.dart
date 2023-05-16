import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/pages/profile/my_buy_list.dart';
import 'package:reslow/pages/profile/my_sell_list.dart';
import 'package:reslow/pages/profile/myknowhow.dart';
import 'package:reslow/pages/profile/mylikeknowhow.dart';
import 'package:reslow/pages/profile/profile_bottom_sheet.dart';
import 'package:reslow/pages/profile/user_info.dart';
import 'package:reslow/services/auth_modify.dart';
import 'package:reslow/utils/navigator.dart';

import 'package:reslow/utils/shared_preference.dart';
import 'notificationsetting.dart';
import 'notificationpage.dart';
import 'couponlist.dart';
import 'package:reslow/pages/home/recommend.dart';
import 'calendarselection.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (_image != null) {
        _image!.delete();
      }

      _image = File(pickedImage.path);

      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (_) => ProfileBottomSheet(
            selectedImage: _image,
            onConfirmProfileChange: _confirmProfileChange,
          ),
        );
      }
    }
  }

  void _confirmProfileChange() async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_image?.path ?? ""),
    });
    Response response = await addProfilePic(formData);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      setState(() {
        UserPreferences().changeProfilePicture(jsonData["profileImg"]);
      });
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: UserPreferences().getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Column(
              children: [
                // Profile
                Container(
                  height: 140,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: ClipOval(
                              child: Image.network(
                                snapshot.data?.profileImg ?? "",
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              radius: 15,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            snapshot.data?.nickname ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              leftToRightNavigator(const UserInfo(), context);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon:
                                Icon(Icons.notifications, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationPage(),
                                ),
                              );
                            },
                          ),
                          Text(
                            '알림',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.local_offer, color: Colors.white),
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
                          Text(
                            '쿠폰',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.favorite, color: Colors.white),
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
                          Text(
                            '관심',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // konw-how-started
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
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
                                  width:
                                      10), // for spacing between icon and text
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
                                  width:
                                      10), // for spacing between icon and text
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
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Text(
                          '플리마켓',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                                  width:
                                      10), // for spacing between icon and text
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
                                  width:
                                      10), // for spacing between icon and text
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
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.centerLeft,
                          child: const Row(
                            children: [
                              Icon(Icons.attach_money),
                              SizedBox(width: 10),
                              Text(
                                '정산 현황',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Divider(),
                      // Settings
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Text(
                          '설정',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
        } else if (snapshot.hasError) {
          UserPreferences().removeUser(context).then((res) {
            if (res) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            }
          });
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
