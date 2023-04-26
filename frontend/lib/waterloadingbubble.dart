import 'dart:math';
import 'package:flutter/material.dart';

class WaterLoadingBubble extends StatefulWidget {
  final double size;
  final Color color;
  final double waveHeight;
  final double waveSpeed;
  final double verticalOffset;
  final Color color2; // new wave color
  final double waveHeight2; // new wave height
  final double waveSpeed2; // new wave speed
  final double verticalOffset2; // new wave vertical offset
  final Color color3; // new wave color
  final double waveHeight3; // new wave height
  final double waveSpeed3; // new wave speed
  final double verticalOffset3; // new wave vertical offset

  WaterLoadingBubble({
    this.size = 120,
    this.color = Colors.lightBlue,
    this.color2 = Colors.blue,
    this.color3 = Colors.lightBlueAccent,
    this.waveHeight = 500, // wave size
    this.waveHeight2 = 500, // wave size
    this.waveHeight3 = 500, // wave size
    this.waveSpeed = 0.2,
    this.waveSpeed2 = 0.2,
    this.waveSpeed3 = 0.2,
    this.verticalOffset = 650, // wave y-axis position (opposite)
    this.verticalOffset2 = 650,
    this.verticalOffset3 = 650,
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

  Widget _buildWave(
      double height, double speed, double time, double offset, Color color) {
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
                  color.withOpacity(0.5),
                  color.withOpacity(0.7),
                  color,
                  color,
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
              return _buildWave(
                widget.waveHeight,
                widget.waveSpeed,
                _controller.value,
                widget.verticalOffset,
                widget.color,
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _buildWave(
                widget.waveHeight2,
                widget.waveSpeed2,
                _controller.value - 1.2, // x-axis 위치 조정
                widget.verticalOffset2,
                widget.color2,
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _buildWave(
                widget.waveHeight3,
                widget.waveSpeed3,
                _controller.value - 2.4, // x-axis 위치 조정
                widget.verticalOffset3,
                widget.color3,
              );
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
      (time * 100) % size.height;
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
