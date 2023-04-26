import 'dart:math';
import 'package:flutter/material.dart';

class WaterLoadingBubble extends StatefulWidget {
  final double size;
  final Color color;
  final double waveHeight;
  final double waveSpeed;

  WaterLoadingBubble({
    this.size = 80,
    this.color = Colors.blueAccent,
    this.waveHeight = 10,
    this.waveSpeed = 0.2,
  });

  @override
  _WaterLoadingBubbleState createState() => _WaterLoadingBubbleState();
}

class _WaterLoadingBubbleState extends State<WaterLoadingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWave(double height, double speed, double time) {
    return ClipPath(
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(0.5),
              widget.color.withOpacity(0.7),
              widget.color,
              widget.color,
            ],
            stops: [0.1, 0.3, 0.7, 1],
          ),
        ),
      ),
      clipper: WaveClipper(time, speed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _buildWave(
                  widget.waveHeight, widget.waveSpeed, _controller.value);
            },
          ),
          Center(
            child: Container(
              width: widget.size / 2,
              height: widget.size / 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(widget.color),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double time;
  final double speed;

  WaveClipper(this.time, this.speed);

  @override
  Path getClip(Size size) {
    var path = Path();
    double x = 0;
    double y = size.height / 2;

    path.moveTo(x, y);

    while (x < size.width) {
      y = size.height / 2 +
          sin((x / size.width * 2 * pi) + (time * 2 * pi * speed)) *
              size.height /
              5;
      path.lineTo(x, y);
      x += 1;
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
