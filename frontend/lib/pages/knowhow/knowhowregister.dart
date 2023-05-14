import 'package:dio/dio.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KnowhowRegister extends StatefulWidget {
  const KnowhowRegister({Key? key}) : super(key: key);

  @override
  _KnowhowRegisterState createState() => _KnowhowRegisterState();
}

class _KnowhowRegisterState extends State<KnowhowRegister> {
  Future<void> _requestRegister() async {
    //제목 선택했는지 확인
    if (title == "") {
      FlutterDialog("글의 제목을 입력해주세요");
      return;
    }
    //카테고리 선택했는지 확인
    if (knowhowregicategory == -1) {
      FlutterDialog("글의 카테고리를 선택해주세요");
      return;
    }
    //글, 사진 쌍 잘 들어가있는지 확인
    for (int i = 0; i < pickedImgs.length; i++) {
      if (contentTexts[i] == "") {
        FlutterDialog("${i + 1}번째 내용을 채워주세요");
        return;
      }
      if (pickedImgs[i].length == 0) {
        FlutterDialog("${i + 1}번째 사진을 채워주세요");
        return;
      }
    }

    final Dio dio = Dio();

    List<dynamic> imageList = [];

    for (int i = 0; i < pickedImgs.length; i++) {
      final String filename = pickedImgs[i][0].path.split('/').last;
      final List<int> bytes = await pickedImgs[i][0].readAsBytes();
      imageList.add(await MultipartFile.fromBytes(bytes, filename: filename));
    }
    FormData formData = FormData.fromMap({
      "categoryNo": knowhowregicategory + 1,
      "title": title,
      "contentList": contentTexts,
      "imageList": imageList
    });

    // FormData formData = FormData.fromMap({"knowhowNo": 1, "files": imageList});
    print(formData);

    final token = await _getTokenFromSharedPreferences();
    print("token $token");

    try {
      final response = await dio.post(
        'http://k8b306.p.ssafy.io:8080/knowhows/',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      ); // Use the appended endpoint
      Navigator.pop(context);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa ${response.data}");
    } on DioError catch (e) {
      print('error: $e');
    }
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  final formKey = GlobalKey<FormState>();
  int selected = -1;
  String title = "";

  int number = 1;
  List<List<XFile>> pickedImgs = [[]];
  List<String?> contentTexts = [""];
  List<TextEditingController> textCtr = [TextEditingController()];

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImg(int index) async {
    final List<XFile>? images = await _picker.pickMultiImage();
    print("이미지${images}");
    if (images != null && images.length != 0) {
      setState(() {
        pickedImgs[index] = images;
      });
      print(pickedImgs[index][0].path);
    }
  }

  Future<void> _changeText(int index, String? text) async {
    setState(() {
      contentTexts[index] = text;
    });
    // print(index);
    // print(text);
    // print("뭐야왜안찍혀 $contentTexts");
  }

  Future<void> _makeImgAndText() async {
    setState(() {
      pickedImgs.add([]);
      contentTexts.add("");
      textCtr.add(TextEditingController());
    });
    number++;
    // print(number);
  }

  Future<void> _deleteImgAndText(int index) async {
    setState(() {
      pickedImgs.removeAt(index);
      contentTexts.removeAt(index);
      textCtr.removeAt(index);
    });
    number--;
    // print("DELETE");
    // print(index);
    // print(number);
  }

  void FlutterDialog(String text) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("알림"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget picAndText(int index) {
    return Column(
      key: Key("content$index"),
      children: [
        index != 0
            ? InkWell(
                onTap: () => {_deleteImgAndText(index)},
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                      margin: const EdgeInsets.all(16),
                      child: Image.asset("assets/image/close.png", width: 20)),
                ]))
            : const Text(""),
        InkWell(
            onTap: () => {_pickImg(index)},
            child: SingleChildScrollView(
                child: pickedImgs[index].isEmpty
                    ? Container(
                        margin: const EdgeInsets.all(16),
                        color: Colors.grey.withOpacity(0.2),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: Container(
                            margin: const EdgeInsets.all(16),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/camera.png",
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                  const Text("사진을 업로드하려면 누르세요!")
                                ])))
                    : Container(
                        margin: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: Image.file(
                          File(pickedImgs[index][0].path),
                          fit: BoxFit.cover,
                        )))),
        SizedBox(
            child: TextFormField(
          onChanged: (text) {
            _changeText(index, text);
          },
          controller: textCtr[index],
          validator: (value) {
            if (value == "") {
              return "내용은 한 글자 이상이어야 합니다.";
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: '내용을 입력해주세요.',
            labelStyle: TextStyle(color: Color(0xffDBDBDB)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffDBDBDB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffDBDBDB)),
            ),
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
        )),
        Image.asset("assets/image/dots.png", width: 40)
      ],
    );
  }

  Widget categoryTag(int index, String tagname) {
    return Container(
      key: Key("category$index"),
      margin: const EdgeInsets.only(left: 10.0),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all<Color>(const Color(0xff555555)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                  width: 2,
                  color: selected == index
                      ? const Color(0xff165B40)
                      : const Color(0xffE0E0E0)),
            ),
          ),
        ),
        child: Text(tagname),
        onPressed: () {
          setState(() => selected = index);
        },
      ),
    );
  }

  int knowhowregicategory = -1;

  void _getCategory(int index) {
    knowhowregicategory = index;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: '노하우 글쓰기',
        actions: '완료',
        callback: _requestRegister,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: const Color(0xffDBDBDB)),
        Row(children: [
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              width: MediaQuery.of(context).size.width * 0.16,
              child: const Text(
                "카테고리",
                style: TextStyle(fontSize: 16),
              )),
          Container(width: 1, height: 30, color: const Color(0xffDBDBDB)),
          Expanded(
            child: CategoryTapBar(
              callback: _getCategory,
            ),
          )
        ]),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: const Color(0xffDBDBDB)),
        Container(
            child: TextField(
          onChanged: (text) {
            setState(() {
              title = text;
            });
          },
          decoration: const InputDecoration(
            hintText: '노하우 글의 제목을 입력해주세요.',
            labelStyle: TextStyle(color: Color(0xffDBDBDB)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffDBDBDB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffDBDBDB)),
            ),
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          keyboardType: TextInputType.text,
        )),
        Expanded(
          child: Form(
              key: formKey,
              child: ListView.builder(
                  itemCount: number,
                  itemBuilder: ((context, index) {
                    return picAndText(index);
                  }))),
        ),
        TextButton(
            onPressed: () => {
                  setState(() {
                    _makeImgAndText();
                  })
                },
            child: Text("사진 + 글 추가")),
      ]),
    ));
  }
}
