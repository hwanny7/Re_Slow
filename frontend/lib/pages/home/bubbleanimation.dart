import 'package:flutter/material.dart';

class BubblesAnimation extends StatefulWidget {
  final List<String> tags;

  BubblesAnimation({required this.tags});

  @override
  _BubblesAnimationState createState() => _BubblesAnimationState();
}

class _BubblesAnimationState extends State<BubblesAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<double> _bubbleSizes;
  late List<Offset> _bubblePositions;

  @override
  void initState() {
    super.initState();
    _controllers = [
      AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      ),
      AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      ),
      AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      ),
    ];
    _animations = _controllers
        .map(
            (controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();
    _bubbleSizes = [50.0, 70.0, 90.0];
    _bubblePositions = [Offset(0, 0), Offset(0, 0), Offset(0, 0)];

    // Start the animation
    for (int i = 0; i < widget.tags.length; i++) {
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.tags.length; i++) {
      _controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < widget.tags.length; i++)
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _bubblePositions[i].dy,
            left: _bubblePositions[i].dx,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 1),
              builder: (BuildContext context, double value, Widget? child) {
                return Container(
                  width: _bubbleSizes[i] * value,
                  height: _bubbleSizes[i] * value,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.tags[i],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
