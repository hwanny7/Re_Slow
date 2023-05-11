import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reslow/pages/frame.dart';
import 'package:reslow/pages/knowhow/knowhow.dart';
import 'package:reslow/pages/market/market.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/socket_provider.dart';
import 'package:reslow/providers/user_provider.dart';
import 'package:reslow/utils/shared_preference.dart';
import 'package:reslow/pages/knowhow/knowhowregister.dart';
import 'pages/auth/login.dart';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => SocketManager())
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
