import 'package:flutter/material.dart';
import 'pages/frame.dart';
import 'pages/auth/login.dart';
import 'landingpage.dart'; // Import landingpage widget here

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
      initialRoute: '/',
      routes: {
        // '/': (context) => MainPage(key: key),
        '/main': (context) => MainPage(),
        '/': (context) => LandingPage(),
        '/login': (context) => Login(key: key),
      },
    );
  }
}
