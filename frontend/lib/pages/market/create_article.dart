import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateArticle extends StatefulWidget {
  const CreateArticle({Key? key}) : super(key: key);

  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  List<File> selectedImages = [];

  Future<void> _openMultiImagePicker() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path);
        print(imageFile);
        setState(() {
          selectedImages.add(imageFile);
        });
      }
    } else {
      print('empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    String title = '';
    print(title.isEmpty);
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: '내 물건 등록',
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: _openMultiImagePicker,
                      child: Text('Select Images'),
                    ),
                    Container(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(selectedImages[index]),
                            );
                          },
                        ))
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: '글제목',
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDBDBD))),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                  onChanged: (value) => {
                    setState(() {
                      title = value;
                    })
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '가격',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '배송비',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: '게시글 내용을 작성해주세요.',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                ),
              ],
            )));
  }
}
