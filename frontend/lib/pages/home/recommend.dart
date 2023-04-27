import 'dart:math';

import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 32.0),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Text(
                    '추천',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
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
                    horizontal: 50.0, vertical: 10.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    SlideTransition(
                      position: _animation,
                      child: Transform.translate(
                        offset: Offset(-20, 0),
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade300.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    SlideTransition(
                      position: _animation,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade600.withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    SlideTransition(
                      position: _animation,
                      child: Transform.translate(
                        offset: Offset(20, 0),
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade900.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          // Drawed Bubbles
        ],
      ),
    );
  }
}
