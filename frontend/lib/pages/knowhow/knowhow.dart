import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/profile_small.dart';
import 'package:reslow/widgets/knowhow/knowhow_grid.dart';
import 'package:reslow/widgets/common/search_bar.dart';
import 'package:reslow/widgets/common/category_tap_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnowHow extends StatefulWidget {
  const KnowHow({Key? key}) : super(key: key);
  @override
  _KnowHowState createState() => _KnowHowState();
}

List<dynamic> content = [];

List<dynamic> heartYN = [
  {"YN": true},
  {"YN": false},
];

int _selectedindex = -1;

class _KnowHowState extends State<KnowHow> {
  Dio dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    _requestKnowhow().then((data) {
      print(data);
      setState(() {
        content = data;
      });
    });
    super.initState();
  }

  Future<List> _requestKnowhow() async {
    try {
      final token = await _getTokenFromSharedPreferences();
      print("token $token");
      final response = await dio.get('http://k8b306.p.ssafy.io:8080/knowhows/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          queryParameters: {
            "page": 1,
            "size": 10,
            "category": null,
            "keyword": null
          });
      return response.data;
    } on DioError catch (e) {
      print('error: $e');
      return [];
    }
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(alignment: Alignment.center, child: MySearchBar()),
      const CategoryTapBar(),
      Expanded(
          child: ListView.builder(
              itemCount: content.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileSmall(
                                url: content[index]["profilePic"],
                                name: content[index]["writer"]),
                            Image.asset(
                              "assets/image/share.png",
                              width: 24,
                            )
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color(0xffDBDBDB)),
                    InkWell(
                        onTap: () => {
                              Navigator.pushNamed(context, '/knowhow/:id',
                                  arguments: {
                                    'id': content[index]["knowhowNo"]
                                  })
                            },
                        child: Column(children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(0),
                              child: Center(
                                  child: Column(children: [
                                Center(
                                    child: KnowHowGrid(
                                  images: content[index]["pictureList"],
                                  imageLTH: content[index]["pictureCnt"],
                                ))
                              ]))),
                          Container(
                              margin: const EdgeInsets.all(16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      content[index]["title"],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                heartYN[index]["YN"] =
                                                    !heartYN[index]["YN"];
                                              });
                                            },
                                            child: Row(children: [
                                              Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Image.asset(
                                                    heartYN[index]["YN"]
                                                        ? "assets/image/full_heart.png"
                                                        : "assets/image/heart.png",
                                                    width: 24,
                                                  )),
                                              Text(
                                                "${content[index]["likeCnt"]}",
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              )
                                            ])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () => {},
                                            child: Row(children: [
                                              Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: Image.asset(
                                                    "assets/image/comment.png",
                                                    width: 24,
                                                  )),
                                              Text(
                                                "${content[index]["commentCnt"]}",
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              )
                                            ])),
                                      ],
                                    )
                                  ])),
                        ])),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 8,
                        color: const Color(0xffDBDBDB)),
                  ],
                );
              })),
    ]);
  }
}
