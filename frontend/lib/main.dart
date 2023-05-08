import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reslow/pages/frame.dart';
import 'package:reslow/pages/knowhow/knowhow.dart';
import 'package:reslow/pages/market/buy_item.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/user_provider.dart';
import 'package:reslow/utils/shared_preference.dart';
import 'package:reslow/pages/knowhow/knowhowregister.dart';
import 'pages/auth/login.dart';
import 'splashscreen.dart';
// FCM
import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';

// FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  var initialzationSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class FirebaseMessagingWidget extends StatefulWidget {
  const FirebaseMessagingWidget({Key? key}) : super(key: key);

  @override
  _FirebaseMessagingWidgetState createState() =>
      _FirebaseMessagingWidgetState();
}

class _FirebaseMessagingWidgetState extends State<FirebaseMessagingWidget> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // handle onMessage event
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // handle onMessageOpenedApp event
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // void initState() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     var androidNotiDetails = AndroidNotificationDetails(
  //       channel.id,
  //       channel.name,
  //       channelDescription: channel.description,
  //     );
  //     var iOSNotiDetails = const IOSNotificationDetails();
  //     var details =
  //         NotificationDetails(android: androidNotiDetails, iOS: iOSNotiDetails);
  //     if (notification != null) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         details,
  //       );
  //     }
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     print(message);
  //   });
  //   super.initState();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
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
            },
            // Add FirebaseMessagingWidget as a child of FutureBuilder
            // child: FirebaseMessagingWidget(),
            //  initialRoute: '/firebase-messaging',
          ),
          theme: ThemeData(fontFamily: "NanumSquare"),
          routes: {
            '/main': (context) => const MainPage(),
            '/splash': (context) => SplashScreen(),
            '/login': (context) => Login(key: key),
            '/knowhow': (context) => const KnowHow(),
            '/knowhow/register': (context) => const KnowhowRegister(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}
