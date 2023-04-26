import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    required String title,
    Widget? leading,
    List<Widget>? actions,
  }) : super(
          key: key,
          backgroundColor: Colors.blue,
          centerTitle: true,
          elevation: 0,
          leading: leading,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: actions,
        );
}
