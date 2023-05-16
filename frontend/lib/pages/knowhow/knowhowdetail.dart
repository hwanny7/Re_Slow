import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/pages/knowhow/knowhowcomment.dart';
import 'package:reslow/pages/profile/myKnowhow.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:reslow/widgets/common/profile_small.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnowHowDetail extends StatefulWidget {
  final int knowhowNo;
  const KnowHowDetail({Key? key, required this.knowhowNo}) : super(key: key);
  @override
  _KnowHowDetailState createState() => _KnowHowDetailState();
}

class _KnowHowDetailState extends State<KnowHowDetail> {
  Map<dynamic, dynamic> content = {};
  Map heartYN = {"YN": true};
  Dio dio = Dio();

  @override
  void initState() {
    print("initState 시작");
    // TODO: implement initState
    _requestKnowhowDetail().then((data) {
      print("이거 안 나와??$data");
      setState(() {
        content = data;
      });
    }).catchError((error) {
      print(error);
    });
    super.initState();
  }

  Future<Map<String, dynamic>> _requestKnowhowDetail() async {
    print("요청 시작");

    final token = await _getTokenFromSharedPreferences();
    final response = await dio.get(
      'http://k8b306.p.ssafy.io:8080/knowhows/detail/${widget.knowhowNo}',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    print(response.data);
    return response.data;
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: content["title"] ?? "",
            ),
            body: Column(children: [
              Expanded(
                  child: Column(
                children: [
                  // TextButton(
                  //     onPressed: () {
                  //       // Navigate to my account settings page
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => MyKnowhow()), //나의 노하우 글 페이지로 이동
                  //       );
                  //     },
                  //     child: Text("나의 노하우 글 보기")),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProfileSmall(
                          url: content["profilePic"],
                          name: content["writer"] ?? ""),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: Text(
                            content["date"] ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                            ),
                          ))
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: const Color(0xffDBDBDB)),
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
                          Row(
                            children: [
                              InkWell(
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Knowhowcomment(
                                                    knowhowid:
                                                        widget.knowhowNo),
                                          ),
                                        )
                                      },
                                  child: Row(children: [
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 0),
                                        child: Image.asset(
                                          "assets/image/comment.png",
                                          width: 24,
                                        )),
                                    Text(
                                      "${content["comment"] ?? ""}",
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  ])),
                            ],
                          )
                        ],
                      ))
                ],
              ))
            ])));
  }
}
