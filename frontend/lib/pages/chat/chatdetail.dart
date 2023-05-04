import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/pages/knowhow/knowhowcomment.dart';
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
  "username": "춘식이 집사3",
  "otherimage": "assets/image/user.png",
  "othername": "춘식이 집사3",
  "chat": [
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
    return Container();
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
                          itemCount: content["contentList"] == null
                              ? 0
                              : content["contentList"].length,
                          itemBuilder: (context, index) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 16, 0, 16),
                                      child: Image.asset(
                                          "assets/image/dots.png",
                                          width: 30)),
                                  Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: content["contentList"][index]
                                                  ["image"] ==
                                              null
                                          ? Image.asset(
                                              "assets/image/error.png",
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              content["contentList"][index]
                                                  ["image"],
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            )),
                                  Container(
                                      margin: const EdgeInsets.all(16),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              content["contentList"][index]
                                                      ["content"] ??
                                                  "",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100,
                                                height: 1.4,
                                              ),
                                            ))
                                          ])),
                                ]);
                          })),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: const Color(0xffDBDBDB)),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      heartYN["YN"] = !heartYN["YN"];
                                    });
                                  },
                                  child: Row(children: [
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 0),
                                        child: Image.asset(
                                          (content["like"] ?? false)
                                              ? "assets/image/full_heart.png"
                                              : "assets/image/heart.png",
                                          width: 24,
                                        )),
                                    Text(
                                      "${content["likecnt"] ?? ""}",
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  ])),
                            ],
                          ),
                        ],
                      ))
                ],
              ))
            ])));
  }
}
