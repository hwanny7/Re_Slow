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
            color: Colors.white,
            child: Center(
              child: Transform.scale(
                scale: 1.5, // adjust the scale factor as needed
                child: Image.asset("assets/image/Logo_Reslow.png"),
              ),
            ),
          ),
          Center(
            child: WaterLoadingBubble(
              size: 100,
              color: Colors.blue.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
