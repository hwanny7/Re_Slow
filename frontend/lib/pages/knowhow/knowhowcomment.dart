import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Knowhowcomment extends StatefulWidget {
  final int knowhowid;

  const Knowhowcomment({Key? key, required this.knowhowid}) : super(key: key);

  @override
  _KnowhowcommentState createState() => _KnowhowcommentState();
}

class _KnowhowcommentState extends State<Knowhowcomment> {
  Dio dio = Dio();
  List<dynamic> content = [];

  int category = 0;
  String commentText = "";
  TextEditingController _commentController = TextEditingController();
  String cocommentText = "";

  void _getCategory(int index) {
    category = index;
  }

  @override
  void initState() {
    // TODO: implement initState
    _requestComment();
    super.initState();
  }

  Future<void> _requestComment() async {
    try {
      final token = await _getTokenFromSharedPreferences();
      print("token $token");
      final response = await dio.get(
          'http://k8b306.p.ssafy.io:8080/knowhows/comments/',
          queryParameters: {"knowhowNo": widget.knowhowid}).then(
        (value) {
          setState(() {
            content = value.data["content"];
          });
        },
      );
    } on DioError catch (e) {
      print('error: $e');
    }
  }

  Future<void> _registerComment() async {
    try {
      final token = await _getTokenFromSharedPreferences();
      print("token $token");
      final response = await dio.post(
        'http://k8b306.p.ssafy.io:8080/knowhows/comments/',
        data: {"knowhowNo": widget.knowhowid, "content": commentText},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      setState(() {
        commentText = "";
      });
      _requestComment();
    } on DioError catch (e) {
      print('error: $e');
    }
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Widget cocomment(Map item) {
    return Row(children: [
      Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.grey, style: BorderStyle.solid, width: 0.5)),
          margin: EdgeInsets.fromLTRB(48, 16, 16, 16),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: item["profilePic"] == null
                  ? Image.asset(
                      "assets/image/user.png",
                      width: 48,
                    )
                  : Image.network(item["profilePic"], width: 50))),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.69,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      child: Text(
                        item["nickname"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      child: Text(
                        item["datetime"],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w100),
                      ))
                ])),
        Container(
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Text(
              item["content"],
              style: const TextStyle(fontSize: 14),
            )),
      ])
    ]);
  }

  Widget comment(int index) {
    return Column(children: [
      Row(children: [
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.grey, style: BorderStyle.solid, width: 0.5)),
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: ClipOval(
                child: content[index]["profilePic"] == null
                    ? Image.asset(
                        "assets/image/user.png",
                        width: 50,
                        height: 50,
                      )
                    : Image.network(
                        content[index]["profilePic"],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.76,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          child: Text(
                            content[index]["nickname"] ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                          child: Text(
                            content[index]["datetime"] ?? "",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w100),
                          ))
                    ])),
            Container(
                margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Text(
                  content[index]["content"] ?? "",
                  style: const TextStyle(fontSize: 14),
                )),
          ],
        ),
      ]),
      Column(
          children: content[index]["children"] != null
              ? List<Widget>.from(
                  content[index]["children"].map((item) => cocomment(item)))
              : [])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: "댓글${content.length}",
            ),
            body: Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: const Color(0xffDBDBDB)),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: content.length,
                      itemBuilder: (context, index) {
                        return comment(index);
                      })),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.838,
                    child: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          commentText = text;
                        });
                      },
                      validator: (value) {
                        if (value == "") {
                          return "내용은 한 글자 이상이어야 합니다.";
                        }
                        return null;
                      },
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: '댓글을 입력해주세요!',
                        labelStyle: TextStyle(color: Color(0xffDBDBDB)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffDBDBDB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffDBDBDB)),
                        ),
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    )),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.4))),
                    height: 94,
                    child: TextButton(
                        onPressed: () {
                          _registerComment();
                          _commentController.clear();
                        },
                        child: Text("완료")))
              ])
            ])));
  }
}
