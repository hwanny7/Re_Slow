import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend>
    with SingleTickerProviderStateMixin {
  final List<String> _tags = [];
  final TextEditingController _textController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, 0.08),
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
    });
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: '추천'),
      body: Column(
        children: [
          Padding(
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
            padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                decoration: InputDecoration(
                  hintText: '사용하실 재료를 입력해주세요!',
                  border: InputBorder.none,
                ),
                onSubmitted: (String value) {
                  _textController.clear();
                  _addTag(value);
                },
              ),
            ),
          ),
          SizedBox(height: 16.0),

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
                    // Bubble 1
                    SlideTransition(
                      position: _animation,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
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
                            offset: Offset(-20, 0),
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
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/image 1.png'),
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
                                              padding: EdgeInsets.all(8),
                                              child: ClipOval(
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/image/test.jpg'),
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
                                              '리폼왕 춘식이',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '톡톡튀는 청바지 리폼 Tip!',
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
                                                    Icon(Icons.favorite_border),
                                                    SizedBox(width: 8),
                                                    Text('27'),
                                                  ],
                                                ),
                                                SizedBox(width: 16),
                                                Row(
                                                  children: [
                                                    Icon(Icons.comment),
                                                    SizedBox(width: 8),
                                                    Text('57'),
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
                      padding: EdgeInsets.only(left: 180.0, top: 30),
                      child: SlideTransition(
                        position: _animation,
                        child: Image.asset(
                          "assets/image/turtle.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Bubble 2
                    SlideTransition(
                      position: _animation,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
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
                            offset: Offset(20, 0),
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
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/image 4.png'),
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
                                              padding: EdgeInsets.all(8),
                                              child: ClipOval(
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/image/test.jpg'),
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
                                              '리폼왕 춘식이',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '나만의 다꾸 Tip!',
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
                                                    Icon(Icons.favorite_border),
                                                    SizedBox(width: 8),
                                                    Text('33'),
                                                  ],
                                                ),
                                                SizedBox(width: 16),
                                                Row(
                                                  children: [
                                                    Icon(Icons.comment),
                                                    SizedBox(width: 8),
                                                    Text('5'),
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
                      padding: EdgeInsets.only(right: 180.0, top: 30),
                      child: SlideTransition(
                        position: _animation,
                        child: Image.asset(
                          "assets/image/turtle_reversed.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Bubble 3
                    SlideTransition(
                      position: _animation,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // image: DecorationImage(
                                //   image: AssetImage(
                                //       'assets/image/image 1.png'),
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ),
                          ),
                          // flexible rectangular box
                          Transform.translate(
                            offset: Offset(0, 0),
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
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/image 5.png'),
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
                                              padding: EdgeInsets.all(8),
                                              child: ClipOval(
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/image/test.jpg'),
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
                                              '리폼왕 춘식이',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '성경책 커스터마이징 Tip!',
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
                                                    Icon(Icons.favorite_border),
                                                    SizedBox(width: 8),
                                                    Text('44'),
                                                  ],
                                                ),
                                                SizedBox(width: 16),
                                                Row(
                                                  children: [
                                                    Icon(Icons.comment),
                                                    SizedBox(width: 8),
                                                    Text('12'),
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          // Drawed Bubbles
        ],
      ),
    ));
  }
}
