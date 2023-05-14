import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    required String title,
    String? register,
    Widget? leading,
    String actions = '',
    dynamic Function()? callback,
    // List<Widget>? actions,
  }) : super(
          key: key,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0,
          leading: leading,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                child: GestureDetector(
                    child: Text(
                      actions,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      callback!();
                    })),
          ],
        );
}
