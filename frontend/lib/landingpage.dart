import 'package:flutter/material.dart';
import 'main.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/main');
      },
      child: Scaffold(
        body: Container(
          color: Colors.blue.shade100,
          child: Center(child: Text("Landing Page")),
        ),
      ),
    );
  }
}
