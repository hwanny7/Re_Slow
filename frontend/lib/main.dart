import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reslow/pages/frame.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/user_provider.dart';
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          title: 'My App',
          // home: MainPage(key: key),
          theme: ThemeData(fontFamily: "NanumSquare"),
          initialRoute: '/login',
          routes: {
            '/main': (context) => MainPage(key: key),
            // '/': (context) => SplashScreen(),
            '/login': (context) => Login(key: key),
          },
        ));
  }
}
