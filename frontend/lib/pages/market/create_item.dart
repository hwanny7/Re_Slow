import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/pages/market/item_detail.dart';
import 'package:reslow/pages/market/market.dart';
import 'package:reslow/utils/dio_client.dart';
import 'package:reslow/utils/navigator.dart';
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
  List<File> selectedImages = [];
  int? category;
  bool isSubmit = false;

  final DioClient dioClient = DioClient();
  final int maxImageCount = 10;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryFeeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    deliveryFeeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _getCategory(int index) {
    category = index;
  }

  Future<void> _openMultiImagePicker() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path);
        setState(() {
          selectedImages.add(imageFile);
        });
      }
    } else {
      print('empty');
    }
  }

  void fetchData(
    formData,
  ) async {
    // Perform the HTTP GET request here
    // For example, using the http package
    isSubmit = true;
    Response response = await dioClient.dio.post('/products',
        data: formData, options: Options(contentType: 'multipart/form-data'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = response.data;
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: ItemDetail(itemPk: jsonData['productNo']),
              );
            },
          ),
        );
      }
    } else {
      isSubmit = false;
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  void _submit() async {
    if (isSubmit) return;

    List<String> errorMessage = [];

    final title = titleController.text;
    final description = descriptionController.text;
    final deliveryFee = deliveryFeeController.text;
    final price = priceController.text;

    if (category == null) {
      errorMessage.add('카테고리');
    }
    if (selectedImages.isEmpty) {
      errorMessage.add('사진');
    }
    if (title.isEmpty) {
      errorMessage.add('제목');
    }
    if (price.isEmpty) {
      errorMessage.add('가격');
    }
    if (description.isEmpty) {
      errorMessage.add('내용');
    }

    if (errorMessage.isNotEmpty) {
      String combinedError = errorMessage.join(', ') +
          (errorMessage.last == "카테고리" ? '는 필수 입력 항목이에요.' : '은 필수 입력 항목이에요.');
      showErrorModal(context, combinedError);
    } else {
      FormData formData = FormData.fromMap({
        "category": category! + 1,
        "title": title,
        "price": price,
        "description": description,
        "deliveryFee": deliveryFee.isEmpty ? 0 : deliveryFee
      });

      for (var image in selectedImages) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(image.path),
          ),
        );
      }

      fetchData(formData);
    }
  }

  void showErrorModal(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: '내 물건 등록',
              actions: '완료',
              callback: _submit,
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                    height: height * 0.15,
                    padding: EdgeInsets.all(16.0),
                    child: ListView.builder(
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
                                  selectedImages[index - 1],
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
                CategoryTapBar(
                  callback: _getCategory,
                  initNumber: category,
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: '글제목',
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDBDBD))),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '가격',
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDBDBD))),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                ),
                TextField(
                  controller: deliveryFeeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '배송비 (선택사항)',
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDBDBD))),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: '게시글 내용을 작성해주세요.',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.04),
                  ),
                ),
              ],
            ))));
  }
}
