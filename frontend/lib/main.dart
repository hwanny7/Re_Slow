import 'package:flutter/material.dart';
import 'package:reslow/pages/frame.dart';
import 'package:reslow/pages/knowhow/knowhow.dart';
import 'package:reslow/pages/knowhow/knowhowdetail.dart';
import 'pages/auth/login.dart';
import 'splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // home: MainPage(key: key),
      theme: ThemeData(fontFamily: "NanumSquare"),
      initialRoute: '/',
      routes: {
        // '/': (context) => MainPage(key: key),
        '/main': (context) => const MainPage(),
        '/': (context) => SplashScreen(),
        '/login': (context) => Login(key: key),
        '/knowhow': (context) => const KnowHow(),
        '/knowhow/:id': (context) => const KnowHowDetail(),
      },
    );
  }
}
