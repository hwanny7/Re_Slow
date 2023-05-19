import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reslow/models/knowhow_item.dart';
import 'package:reslow/pages/knowhow/knowhowcomment.dart';
import 'package:reslow/pages/knowhow/knowhowdetail.dart';
import 'package:reslow/utils/navigator.dart';
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

// List<dynamic> itemList = [];

int _selectedindex = -1;

class _KnowHowState extends State<KnowHow> {
  Dio dio = Dio();
  List<KnowhowItem> itemList = [];
  final ScrollController _scrollController = ScrollController();
  bool knowhowisLoading = false;
  bool knowhowisLast = false;
  int knowhowcategory = 0;
  int knowhowpage = 0;
  String knowhowSearchText = "";
  // 사진 개수에 따라 사진 배치

  void _getCategory(int index) {
    knowhowcategory = index;
    _requestKnowhow(false);
  }

  void _getSearchText(String text) {
    knowhowSearchText = text;
    _requestKnowhow(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    _requestKnowhow(false);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController.position != null &&
        _scrollController.position.pixels >
            _scrollController.position.maxScrollExtent * 0.8 &&
        !knowhowisLast &&
        !knowhowisLoading) {
      knowhowisLoading = true;
      knowhowpage += 1;
      await _requestKnowhow(true);
      knowhowisLoading = false;
    }
  }

  void _refresh() async {
    setState(() {});
  }

  Future<void> _requestKnowhow(bool isInfinite) async {
    try {
      print(knowhowpage);
      if (!isInfinite) {
        knowhowpage = 0;
        knowhowisLast = false;
      }
      final token = await _getTokenFromSharedPreferences();
      print("token $token");
      final response = await dio.get('http://k8b306.p.ssafy.io:8080/knowhows/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          queryParameters: {
            "page": knowhowpage,
            "size": 4,
            "category": knowhowcategory == 0 ? "" : knowhowcategory,
            "keyword": knowhowSearchText
          }).then(
        (value) {
          List<dynamic> jsonData = value.data;
          // print(jsonData);
          if (isInfinite) {
            if (jsonData.isEmpty) {
              knowhowisLast = true;
              print('empty');
            } else {
              setState(() {
                itemList.addAll(List<KnowhowItem>.from(jsonData
                    .map((itemJson) => KnowhowItem.fromJson(itemJson))));
                // 높이를 처음으로 변경하기
              });
            }
          } else {
            _scrollController.jumpTo(0);
            setState(() {
              itemList = List<KnowhowItem>.from(
                  jsonData.map((itemJson) => KnowhowItem.fromJson(itemJson)));
            });
          }
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

  Future<void> _requestKnowhowLike(
      int KnowhowNo, bool isLike, int index) async {
    try {
      if (isLike) {
        final token = await _getTokenFromSharedPreferences();
        print("token $token");
        final response = await dio
            .post('http://k8b306.p.ssafy.io:8080/knowhows/${KnowhowNo}/like',
                options: Options(headers: {
                  'Authorization': 'Bearer $token',
                }))
            .then((value) {
          setState(() {
            itemList[index].likeCnt = value.data["count"];
          });
          print(value);
        });
      } else {
        final token = await _getTokenFromSharedPreferences();
        print("token $token");
        final response = await dio
            .delete('http://k8b306.p.ssafy.io:8080/knowhows/${KnowhowNo}/like',
                options: Options(headers: {
                  'Authorization': 'Bearer $token',
                }))
            .then((value) {
          setState(() {
            itemList[index].likeCnt = value.data["count"];
          });
          print(value);
        });
      }
    } on DioError catch (e) {
      print('likeerror: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.center,
          child: MySearchBar(
            searchcallback: _getSearchText,
          )),
      CategoryTapBar(
        callback: _getCategory,
        initNumber: knowhowcategory,
      ),
      Expanded(
          child: RefreshIndicator(
              onRefresh: () async {
                // Perform the refresh operation here
                // You can call an API, update data, or perform any other action
                // Make sure to await any asynchronous operation

                // Example: Simulating a delay of 2 seconds before completing the refresh
                await Future.delayed(Duration(seconds: 2));

                // Once the refresh operation is completed, update the UI as needed
                _requestKnowhow(false);
              },
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: itemList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileSmall(
                                        url: itemList[index].profile,
                                        name: itemList[index].writer),
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
                                      // leftToRightNavigator(
                                      //     KnowHowDetail(
                                      //         knowhowNo:
                                      //             itemList[index].knowhowNo),
                                      //     context)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => KnowHowDetail(
                                              knowhowNo:
                                                  itemList[index].knowhowNo),
                                        ),
                                      )
                                    },
                                child: Column(children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.all(0),
                                      child: Center(
                                          child: Column(children: [
                                        Center(
                                            child: KnowHowGrid(
                                          images: itemList[index].pictureList,
                                          imageLTH: itemList[index].pictureCnt,
                                        ))
                                      ]))),
                                  Container(
                                      margin: const EdgeInsets.all(16),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  itemList[index].title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        itemList[index].like =
                                                            !itemList[index]
                                                                .like;
                                                      });
                                                      _requestKnowhowLike(
                                                          itemList[index]
                                                              .knowhowNo,
                                                          itemList[index].like,
                                                          index);
                                                    },
                                                    child: Row(children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  8, 0, 8, 0),
                                                          child: Image.asset(
                                                            (itemList[index]
                                                                        .like ??
                                                                    false)
                                                                ? "assets/image/full_heart.png"
                                                                : "assets/image/heart.png",
                                                            width: 24,
                                                          )),
                                                      Text(
                                                        "${itemList[index].likeCnt}",
                                                        style: const TextStyle(
                                                            fontSize: 18),
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
                                                                          itemList[index]
                                                                              .knowhowNo),
                                                            ),
                                                          )
                                                        },
                                                    child: Row(children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  8, 0, 8, 0),
                                                          child: Image.asset(
                                                            "assets/image/comment.png",
                                                            width: 24,
                                                          )),
                                                      Text(
                                                        "${itemList[index].commentCnt}",
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
                      })))),
    ]);
  }
}
