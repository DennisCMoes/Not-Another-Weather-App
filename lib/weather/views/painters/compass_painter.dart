import 'dart:math';

import 'package:flutter/material.dart';

class CompassPainter extends CustomPainter {
  final double angle;
  final Color ringColor;

  CompassPainter({required this.angle, required this.ringColor});

  double get rotation => -2 * pi * (angle / 360);

  Paint get _brush => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = _brush..color = Colors.indigo;
    Paint needle = _brush..color = Colors.red;

    double radius = min(size.width / 2.2, size.height / 2.2);
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset start = Offset.lerp(Offset(center.dx, radius), center, 10)!;
    Offset end = Offset.lerp(Offset(center.dx, radius), center, 6)!;

    // Draw the compass circle
    canvas.drawCircle(center, radius, circle);

    // Rotate the canvas for the needle
    drawCardinalDirection(canvas, center, 'N', Offset(0, -radius + 15));
    drawCardinalDirection(canvas, center, 'E', Offset(radius - 15, 0));
    drawCardinalDirection(canvas, center, 'S', Offset(0, radius - 15));
    drawCardinalDirection(canvas, center, 'W', Offset(-radius + 15, 0));

    // Rotate the canvas for the needle
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    // Draw the needle
    canvas.drawLine(start, end, needle);
    canvas.restore();
  }

  void drawCardinalDirection(
      Canvas canvas, Offset center, String direction, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: direction,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    Offset position =
        center + offset - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
