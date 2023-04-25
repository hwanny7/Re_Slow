import 'package:flutter/material.dart';
import 'pages/frame.dart';
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
        '/main': (context) => MainPage(),
        '/': (context) => SplashScreen(),
        '/login': (context) => Login(key: key),
      },
    );
  }
}
