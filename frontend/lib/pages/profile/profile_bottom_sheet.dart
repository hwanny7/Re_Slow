import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter/material.dart';

class ProfileBottomSheet extends StatefulWidget {
  final File? selectedImage;
  final VoidCallback onConfirmProfileChange;

  ProfileBottomSheet(
      {required this.selectedImage, required this.onConfirmProfileChange});

  @override
  _ProfileBottomSheetState createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: widget.selectedImage != null
          ? MediaQuery.of(context).size.height * 0.3
          : 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
              child: Image.file(
            widget.selectedImage!,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          )),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () {
              widget.onConfirmProfileChange();
            },
            child: Text('프로필 사진 변경하기'),
          ),
        ],
      ),
    );
  }
}
