import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:reslow/utils/dio_client.dart';

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend>
    with SingleTickerProviderStateMixin {
  final DioClient dioClient = DioClient();
  final List<String> _tags = []; //요거를 쿼리 스트링으로 보내줘야
  final TextEditingController _textController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final List<Recommendation> recommendations = [];

  Future<void> fetchRecommendations() async {
    Map<String, String> queryParameters = {};

    for (String tag in _tags) {
      queryParameters['keywords'] = tag;
    }
    print(queryParameters);
    Response response = await dioClient.dio
        .get('/knowhows/recommends', queryParameters: queryParameters);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.data;

      List<Recommendation> newRecommendations =
          jsonData.map((item) => Recommendation.fromJson(item)).toList();
      print(jsonData);

      setState(() {
        recommendations.clear(); // clear out before add
        recommendations.addAll(newRecommendations);
      });

      print(recommendations);
    } else {
      // Handle any errors or display an error message
      print('HTTP request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.08),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag);
      if (_tags.isNotEmpty) {
        fetchRecommendations();
      } else {
        recommendations.clear();
      }
    });
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index); // 유저가 어느걸 삭제할지 모르니까
      if (_tags.isNotEmpty) {
        Map<String, String> queryParameters = {};
        for (String tag in _tags) {
          queryParameters['keywords'] = tag;
        }
        fetchRecommendations();
      } else {
        // If there are less than two tags, clear the recommendations list
        recommendations.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: '추천'),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text(
                  '리폼 물품을 추천해드릴게요!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: '사용하실 재료를 입력해주세요!',
                  border: InputBorder.none,
                ),
                onSubmitted: (String value) {
                  _textController.clear();
                  _addTag(value);
                  // fetchRecommendations();
                },
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Wrap
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _tags
                .asMap()
                .entries
                .map(
                  (entry) => InputChip(
                    label: Text(entry.value),
                    onDeleted: () => _removeTag(entry.key),
                  ),
                )
                .toList(),
          ),

          // Draw Floating Bubbles
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 15.0),
                child: Column(
                  children: [
                    // 입력 안 한 경우
                    if (_tags.isEmpty) Container(), // Nothing

                    // 입력 했는데, 결과가 없는 경우
                    if ((_tags.isNotEmpty && recommendations.isEmpty) ||
                        (_tags.isNotEmpty &&
                            recommendations[0] == null &&
                            recommendations[1] == null &&
                            recommendations[2] == null))
                      Container(
                        width: 300,
                        height: 50,
                        child: Center(
                          child: Text(
                            "검색 결과가 존재하지 않습니다",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                    // 입력 했고, 결과가 있는 경우 (1개-2개-3개 분기처리)
                    // Bubble 1
                    if (recommendations.isNotEmpty &&
                        recommendations[0] != null)
                      SlideTransition(
                        position: _animation,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            // flexible rectangular box
                            Transform.translate(
                              offset: const Offset(-20, 0),
                              child: Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // container start
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          // pictureList 의 첫번째 사진.jpg
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                recommendations[0]
                                                    .pictureList[0]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 110,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            recommendations[0]
                                                                .profile),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //container end

                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                // writer 노하우 글 작성자 이름
                                                recommendations[0].writer,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                recommendations[0].title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .favorite_border),
                                                      SizedBox(width: 8),
                                                      Text(recommendations[0]
                                                          .likeCnt
                                                          .toString()),
                                                    ],
                                                  ),
                                                  SizedBox(width: 16),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.comment),
                                                      SizedBox(width: 8),
                                                      Text(recommendations[0]
                                                          .commentCnt
                                                          .toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //flexible rectangular box
                          ],
                        ),
                      ),
                    // Bubble1 end
                    // Turtle
                    Padding(
                      padding: const EdgeInsets.only(left: 180.0, top: 30),
                      child: SlideTransition(
                        position: _animation,
                        child: Image.asset(
                          "assets/image/turtle.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Bubble 2
                    if (recommendations.isNotEmpty &&
                        recommendations.length > 1 &&
                        recommendations[1] != null)
                      SlideTransition(
                        position: _animation,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // image: DecorationImage(
                                  //   image: AssetImage(
                                  //       'path/to/bubble_background.png'),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                            ),
                            // flexible rectangular box
                            Transform.translate(
                              offset: const Offset(20, 0),
                              child: Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // container start
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          // pictureList 의 첫번째 사진.jpg
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                recommendations[1]
                                                    .pictureList[0]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 110,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            recommendations[1]
                                                                .profile),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //container end

                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                recommendations[1].writer,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                recommendations[1].title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .favorite_border),
                                                      SizedBox(width: 8),
                                                      Text(recommendations[1]
                                                          .likeCnt
                                                          .toString()),
                                                    ],
                                                  ),
                                                  SizedBox(width: 16),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.comment),
                                                      SizedBox(width: 8),
                                                      Text(recommendations[1]
                                                          .commentCnt
                                                          .toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //flexible rectangular box
                          ],
                        ),
                      ),
                    // Bubble 2 end
                    // Turtle_reversed
                    Padding(
                      padding: const EdgeInsets.only(right: 180.0, top: 30),
                      child: SlideTransition(
                        position: _animation,
                        child: Image.asset(
                          "assets/image/turtle_reversed.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Bubble 3
                    if (recommendations.isNotEmpty &&
                        recommendations.length > 2 &&
                        recommendations[2] != null)
                      SlideTransition(
                        position: _animation,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            // flexible rectangular box
                            Transform.translate(
                              offset: const Offset(0, 0),
                              child: Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // container start
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          // pictureList 의 첫번째 사진.jpg
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                recommendations[2]
                                                    .pictureList[0]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 110,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            recommendations[2]
                                                                .profile),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //container end

                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                recommendations[2].writer,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                recommendations[2].title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .favorite_border),
                                                      SizedBox(width: 8),
                                                      Text(recommendations[2]
                                                          .likeCnt
                                                          .toString()),
                                                    ],
                                                  ),
                                                  SizedBox(width: 16),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.comment),
                                                      SizedBox(width: 8),
                                                      Text(recommendations[2]
                                                          .commentCnt
                                                          .toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //flexible rectangular box
                          ],
                        ),
                      ),
                    // Bubble 3 end
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

// 클래스
class Recommendation {
  final int knowhowNo;
  final String writer;
  final String profile;
  final String title;
  final List<String> pictureList;
  final int pictureCnt;
  final int likeCnt;
  final bool like;
  final int commentCnt;

  Recommendation({
    required this.knowhowNo,
    required this.writer,
    required this.profile,
    required this.title,
    required this.pictureList,
    required this.pictureCnt,
    required this.likeCnt,
    required this.like,
    required this.commentCnt,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      knowhowNo: json['knowhowNo'],
      writer: json['writer'],
      profile: json['profile'],
      title: json['title'],
      pictureList: List<String>.from(json['pictureList'] ?? []),
      pictureCnt: json['pictureCnt'] ?? 0,
      likeCnt: json['likeCnt'] ?? 0,
      like: json['like'] ?? false,
      commentCnt: json['commentCnt'] ?? 0,
    );
  }
}
