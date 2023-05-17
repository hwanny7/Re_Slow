import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:reslow/pages/chat/chatdetail.dart';
import 'package:reslow/pages/home/recommend.dart';
import 'package:reslow/pages/knowhow/knowhowcomment.dart';
import 'package:reslow/pages/knowhow/knowhowregister.dart';
import 'package:reslow/pages/market/create_item.dart';
import 'package:reslow/pages/market/order_detail.dart';
import 'package:reslow/providers/fcmtoken_provider.dart';
import 'package:reslow/utils/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat/chat.dart';
import 'home/home.dart';
import 'knowhow/knowhow.dart';
import 'market/market.dart';
import 'profile/profile.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백 받았음 메세지 제목은 ${message.notification?.title}");
  print("받았음 메세지 내용은 ${message.notification?.body}");
  print("받았음 메세지 데이터는 ${message.data}");
  // 백그라운드에서 수신한 FCM 메시지 처리
  _showNotification(message.notification?.title, message.notification?.body);
  // 예를 들어 데이터베이스에 알림 정보 저장 등의 작업 수행 가능
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _showNotification(String? title, String? body) async {
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId', 'channelName',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high);

  final platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics);
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  Dio dio = Dio();

  int _currentIndex = 0;

  final List<Widget> screens = [
    Home(),
    Market(),
    KnowHow(),
    Chat(),
    Profile(),
  ];

  void initFirebaseMessaging() {
    // FirebaseMessaging 설정
    FirebaseMessaging.instance.setAutoInitEnabled(true);

    // 백그라운드에서 수신한 FCM 메시지 처리 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드에서 수신한 FCM 메시지 처리 핸들러 등록
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("포 받았음 메세지 제목은 ${message.notification?.title}");
      print("받았음 메세지 내용은 ${message.notification?.body}");
      print("받았음 메세지 데이터는 ${message.data}");
      _showNotification(
          message.notification?.title, message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.data["type"]);
      print(message.data["senderProfilePic"]);
      print(message.data["senderNickname"]);
      if (message.data["type"] == "CHATTING") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetail(
              roomId: message.data["roomId"],
              otherPic: message.data["senderProfilePic"],
              otherNick: message.data["senderNickname"],
            ),
          ),
        );
      } else if (message.data["type"] == "COMMENT") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Knowhowcomment(knowhowid: message.data["roomId"].toInt()),
          ),
        );
      } else if (message.data["type"] == "ORDER") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderDetail(orderPk: message.data["roomId"].toInt()),
          ),
        );
      }
    });
  }

  // final PageStorageBucket bucket = PageStorageBucket();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _pressedPlus() {
    print('시작!');
    switch (_currentIndex) {
      case 0:
        leftToRightNavigator(Recommend(), context);
        return;
      case 1:
        leftToRightNavigator(const CreateArticle(), context);
        return;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KnowhowRegister()),
        ).then((value) {
          setState(() {});
        });
        return;
    }
    ;
    //   Navigator.push(
    // context,
    // MaterialPageRoute(
    //   builder: (context) => NotificationPage(),
    // ),
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void showNotification(String? title, String? body) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'your payload',
    );
  }

  @override
  void initState() {
    super.initState();
    initFirebaseMessaging(); // initFirebaseMessaging() 메서드 호출
    _updateFCMToken();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  void _updateFCMToken() async {
    print("FCM토큰 받으러 왔어요");
    String? fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BCuQB-Qb6ULUXqwfyenXdLVq56BRx_vP5TBUp2-8_-KsCXhMsWWI5Xdh3P0oP1Z-Yja2TrkVXUtTw6Bux4JPzxI");
    print("fcmToken$fcmToken");
    FCMTokenProvider nowToken =
        Provider.of<FCMTokenProvider>(context, listen: false);
    if (nowToken.fcmToken != fcmToken) {
      print("FCM토큰 업데이트 할 거예요");
      nowToken.setFCMToken(fcmToken);
      _sendFCMToken(nowToken.fcmToken, fcmToken);
    }
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  void _sendFCMToken(String preToken, String? newToken) async {
    try {
      final token = await _getTokenFromSharedPreferences();
      await dio
          .post(
        'http://k8b306.p.ssafy.io:8080/chat/fcm/token',
        data: FormData.fromMap({"preToken": preToken, "newToken": newToken}),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      )
          .then(
        (value) {
          if (value.data["device"] == "ok") {
            FCMTokenProvider nowToken = Provider.of<FCMTokenProvider>(context);
            nowToken.setFCMToken(newToken);
          }
        },
      );
    } on DioError catch (e) {
      print('sendfcmtokenerror: $e');
    }
    ;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _updateFCMToken();
        // 서버로 open 보내기
        print("resumed");
        break;
      case AppLifecycleState.inactive:
        // 서버로 close 보내기
        print("inactive");
        break;
      case AppLifecycleState.detached:
        // 서버로 close 보내기
        print("detached");
        break;
      case AppLifecycleState.paused:
        // 서버로 close 보내기
        print("paused");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: const Color(0xff555555),
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: '홈',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_mall),
              label: '플리마켓',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist),
              label: '노하우',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.textsms),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '프로필',
            ),
          ]),
      floatingActionButton:
          _currentIndex == 0 || _currentIndex == 1 || _currentIndex == 2
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    _pressedPlus();
                  })
              : null,
    ));
  }
}
