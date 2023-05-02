import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateArticle extends StatefulWidget {
  const CreateArticle({Key? key}) : super(key: key);

  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  List<String> selectedImages = [];
  ScrollController? scrollController;
  final DioClient dioClient = DioClient();
  final int maxImageCount = 10;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController!.dispose();
    super.dispose();
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Future<void> _openMultiImagePicker() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        String imageFile = pickedFile.path;
        setState(() {
          selectedImages.add(imageFile);
        });
      }
    } else {
      print('empty');
    }
  }

  void fetchData(formData) async {
    // Perform the HTTP GET request here
    // For example, using the http package

    Response response = await dioClient.dio.post('/products',
        data: formData, options: Options(contentType: 'multipart/form-data'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      print(jsonData);

      // setState(() {
      //   // Update the state with the fetched data
      //   itemList = List<MarketItem>.from(jsonData['content']
      //       .map((itemJson) => MarketItem.fromJson(itemJson)));
      // });
    } else {
      // Handle any errors or display an error message
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void _printing() async {
    var formData = FormData();
    Map<String, dynamic> jsonData = {
      "title": "고양이 밥그릇",
      "description": "냐옹이 밥그릇 예쁘게 리폼했어요~",
      "deliveryFee": 3000,
      "price": 20000,
      "stock": 2,
      "category": 1
    };
    formData.fields.add(MapEntry('Regist', jsonEncode(jsonData)));
    List<MapEntry<String, MultipartFile>> fileList = [];
    for (var imageFile in selectedImages) {
      var file = await MultipartFile.fromFile(imageFile);
      fileList.add(MapEntry('files', file));
    }
    formData.files.addAll(fileList);

    fetchData(formData);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    String title = '';
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: '내 물건 등록',
              actions: '완료',
              callback: _printing,
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    height: height * 0.15,
                    padding: EdgeInsets.all(16.0),
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                              child: TextButton(
                                  onPressed: _openMultiImagePicker,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.photo_camera,
                                            color: Color(0xff3C9F61),
                                          ),
                                          Text('${selectedImages.length}/10')
                                        ],
                                      ))),
                              width: width * 0.25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff3C9F61), // Border color
                                  width: 2.0, // Border width
                                ),
                              ));
                        } else {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 8.0),
                                child: Image.file(
                                  File(selectedImages[index - 1]),
                                  width: width * 0.25,
                                  height: width * 0.25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  top: 10.0,
                                  right: 8.0,
                                  child: Transform.translate(
                                      offset: const Offset(8.0, -8.0),
                                      child: InkWell(
                                          onTap: () => _removeImage(index - 1),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          )))),
                            ],
                          );
                        }
                      },
                    )),
                const CategoryTapBar(),
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
                    hintText: '가격',
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
                    hintText: '배송비',
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
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: '게시글 내용을 작성해주세요.',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                  onChanged: (value) => {
                    setState(() {
                      title = value;
                    })
                  },
                ),
              ],
            ))));
  }
}
