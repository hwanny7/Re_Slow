import 'package:flutter/material.dart';
import 'pages/frame.dart';
import 'pages/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: MainPage(key: key),
      initialRoute: '/login',
      routes: {
        '/': (context) => MainPage(key: key),
        '/login': (context) => Login(key: key),
      },
    );
  }
}
