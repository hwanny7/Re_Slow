import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/pages/knowhow/knowhowcomment.dart';
import 'package:reslow/utils/date.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:reslow/widgets/common/profile_small.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatDetail extends StatefulWidget {
  final int chatNo;
  const ChatDetail({Key? key, required this.chatNo}) : super(key: key);
  @override
  _ChatDetailState createState() => _ChatDetailState();
}

Map<dynamic, dynamic> content = {
  "id": 3,
  "userimage": "assets/image/user.png",
  "username": "리폼왕춘식이",
  "otherimage": "assets/image/user.png",
  "othername": "춘식이 집사3",
  "chat": [
    {
      "sender": 0,
      "chatText": "우앵우앵 이렇게 써도 밖으로 안 튀어나가게 하고 싶어요 가능할까요?",
      "time": "2023-05-03T00:00:00",
    },
    {
      "sender": 1,
      "chatText": "우앵우앵",
      "time": "2023-05-03T00:00:00",
    },
    {
      "sender": 0,
      "chatText": "우앵우앵",
      "time": "2023-05-03T00:00:00",
    },
    {
      "sender": 0,
      "chatText": "우앵우앵",
      "time": "2023-05-03T00:00:00",
    },
    {
      "sender": 1,
      "chatText": "우앵우앵",
      "time": "2023-05-03T00:00:00",
    },
  ]
};
Map heartYN = {"YN": true};

class _ChatDetailState extends State<ChatDetail> {
  Dio dio = Dio();

  @override
  void initState() {
    print("initState 시작");
    // TODO: implement initState
    //_requestChatDetail();
    super.initState();
  }

  Future<void> _requestChatDetail() async {
    print("요청 시작");
    try {
      final token = await _getTokenFromSharedPreferences();
      print("token $token");
      final response = await dio
          .get('http://k8b306.p.ssafy.io:8080/knowhows/',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }))
          .then(
        (value) {
          setState(() {
            content = value.data;
          });
        },
      );
    } on DioError catch (e) {
      print('error: $e');
    }
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Widget _Chat(int index) {
    if (content["chat"][index]["sender"] == 0) {
      return Container(
          margin: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                  child: Text(
                      formatTimeDifference(content["chat"][index]["time"]))),
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffCDE8E8),
                          borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      child: RichText(
                          maxLines: 100,
                          text: TextSpan(
                              text: content["chat"][index]["chatText"],
                              style: const TextStyle(color: Colors.black)))))
            ],
          ));
    } else {
      return Container(
          margin: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/image/user.png",
                    width: 50,
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF1F1F1),
                          borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      child: RichText(
                          maxLines: 100,
                          text: TextSpan(
                              text: content["chat"][index]["chatText"],
                              style: const TextStyle(color: Colors.black))))),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: Text(
                      formatTimeDifference(content["chat"][index]["time"]))),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: content["othername"] ?? "",
            ),
            body: Column(children: [
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: content["chat"].length,
                          itemBuilder: (context, index) {
                            return _Chat(index);
                          })),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: const Color(0xffDBDBDB)),
                ],
              )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.838,
                    child: TextFormField(
                      onChanged: (text) {},
                      validator: (value) {
                        if (value == "") {
                          return "내용은 한 글자 이상이어야 합니다.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: '',
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
                      maxLines: 2,
                    )),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.4))),
                    height: 75,
                    child: TextButton(onPressed: () {}, child: Text("완료")))
              ])
            ])));
  }
}
