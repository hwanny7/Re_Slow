import 'package:flutter/material.dart';
import 'waterloadingbubble.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add code here to load any data or perform any setup required before showing the main screen
    // For example, you can load data from a server or initialize a database
    // You can also use a Future.delayed() method to add a delay before showing the main screen
    // For example: Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/main'));
    // This will delay for 2 seconds before navigating to the '/main' route
    // You can replace '/main' with your own route name
    // If you don't want to add any delay, you can just use Navigator.pushReplacementNamed() directly
    // For example: Navigator.pushReplacementNamed(context, '/main');
    // This will immediately navigate to the '/main' route
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blue.shade100,
            child: Center(
              child: Text(
                "Splash Screen!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
            child: WaterLoadingBubble(
              size: 100,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
