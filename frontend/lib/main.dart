import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:reslow/pages/chat/chatdetail.dart';
import 'package:reslow/pages/frame.dart';
import 'package:reslow/pages/knowhow/knowhow.dart';
import 'package:reslow/pages/market/market.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/fcmtoken_provider.dart';
import 'package:reslow/providers/socket_provider.dart';
import 'package:reslow/providers/user_provider.dart';
import 'package:reslow/utils/shared_preference.dart';
import 'package:reslow/pages/knowhow/knowhowregister.dart';
import 'pages/auth/login.dart';
import 'splashscreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("받았음 메세지 제목은 ${message.notification?.title}");
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

Future<void> initializeNotifications() async {
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeNotifications(); // 알림 초기화
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  void initFirebaseMessaging() {
    // FirebaseMessaging 설정
    FirebaseMessaging.instance.setAutoInitEnabled(true);

    // 백그라운드에서 수신한 FCM 메시지 처리 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드에서 수신한 FCM 메시지 처리 핸들러 등록
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("받았음 메세지 제목은 ${message.notification?.title}");
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
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initFirebaseMessaging(); // initFirebaseMessaging() 메서드 호출
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => SocketManager()),
          ChangeNotifierProvider(create: (_) => FCMTokenProvider())
        ],
        child: MaterialApp(
          title: 'My App',
          home: FutureBuilder<bool>(
              future: UserPreferences().getToken(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.data == true) {
                    return SplashScreen();
                  } else {
                    return const Login();
                  }
                }
              }),
          theme: ThemeData(fontFamily: "NanumSquare"),
          routes: {
            '/main': (context) => const MainPage(),
            '/splash': (context) => SplashScreen(),
            '/login': (context) => Login(),
            '/market': (context) => Market(),
            '/knowhow': (context) => const KnowHow(),
            '/knowhow/register': (context) => const KnowhowRegister(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}
