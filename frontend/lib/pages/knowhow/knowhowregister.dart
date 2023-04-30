import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KnowhowRegister extends StatefulWidget {
  const KnowhowRegister({Key? key}) : super(key: key);

  @override
  _KnowhowRegisterState createState() => _KnowhowRegisterState();
}

class _KnowhowRegisterState extends State<KnowhowRegister> {
  final formKey = GlobalKey<FormState>();
  int selected = -1;
  String title = "";

  int number = 1;
  List<List<XFile>> pickedImgs = [[]];
  List<String?> contentTexts = [""];

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
    print(contentTexts);
  }

  Future<void> _makeImgAndText() async {
    setState(() {
      pickedImgs.add([]);
      contentTexts.add("");
    });
    number++;
    print(number);
  }

  Future<void> _deleteImgAndText(int index) async {
    setState(() {
      pickedImgs.removeAt(index);
      contentTexts.removeAt(index);
    });
    number--;
    print(number);
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
        index != 0 ? 
        InkWell(onTap:() => {
          _deleteImgAndText(index)
        }, 
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Container(margin: const EdgeInsets.all(16), child: Image.asset("assets/image/close.png", width: 20)),])) : const Text(""),
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
          onSaved: (text) {
            _changeText(index, text);
          },
          validator:(value) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(children: [
        Container(
            margin: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width * 0.7,
            child: const Text(
              "노하우 글쓰기",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )),
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
              child: Container(
                  color: Colors.grey.withOpacity(0.03),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            categoryTag(1, "의류"),
                            categoryTag(2, "서적"),
                            categoryTag(3, "가구"),
                            categoryTag(4, "악세사리"),
                            categoryTag(5, "잡화"),
                            categoryTag(6, "잘 넘어가니?")
                          ]))))
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
