import 'dart:math';
import 'package:flutter/material.dart';

class WaterLoadingBubble extends StatefulWidget {
  final double size;
  final Color color;
  final double waveHeight;
  final double waveSpeed;
  final double verticalOffset;

  WaterLoadingBubble({
    this.size = 120,
    this.color = Colors.blueAccent,
    this.waveHeight = 500, // 파도 사이즈
    this.waveSpeed = 0.2,
    this.verticalOffset = 650, // 파도 y축 위치 (반대)
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

  Widget _buildWave(double height, double speed, double time, double offset) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Transform.translate(
        offset: Offset(0, widget.size - height + offset),
        child: ClipPath(
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
          clipper: WaveClipper(time, speed, offset),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size * 4,
      height: widget.size * 3,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _buildWave(widget.waveHeight, widget.waveSpeed,
                  _controller.value, widget.verticalOffset);
            },
          ),
          Positioned(
            top: 200,
            left: 170,
            child: Container(
              width: widget.size / 2,
              height: widget.size / 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
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
  final double verticalOffset;
  WaveClipper(this.time, this.speed, this.verticalOffset);

  @override
  Path getClip(Size size) {
    var path = Path();
    double x = 0;
    double y = size.height / 2 + verticalOffset;

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
