import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui';

class SunPainter extends CustomPainter {
  final Paint linePaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final Paint pointPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10.0;

  final Paint sunPaint = Paint()
    ..color = Colors.yellow
    ..style = PaintingStyle.fill;

  final DateTime currentTime;

  SunPainter({required this.currentTime});

  double calculateSunPositionAngle(DateTime time) {
    // Convert the current time to a value between 0 and 1, where 0 is 6 AM and 1 is 6 PM
    final double fractionalDay = (time.hour + time.minute / 60.0 - 6) / 12.0;

    // Clamp the value between 0 and 1
    final double clampedFractionalDay = fractionalDay.clamp(0.0, 1.0);
    return clampedFractionalDay;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final drawableHeight = size.height;
    final drawableWidth = size.width;

    // Control points for the quadratic bezier curve
    final start = Offset(0, (drawableHeight / 2) + 20);
    final control = Offset(drawableWidth / 2, (drawableHeight / 2) - 50);
    final end = Offset(drawableWidth, (drawableHeight / 2) + 20);

    // Create the path for the quadratic curve
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    canvas.drawPath(path, linePaint);

    // Calculate the sun's position
    final double t = calculateSunPositionAngle(currentTime);
    final sunOffset = getQuadraticBezierPoint(start, control, end, t);

    // Draw the sun
    canvas.drawCircle(sunOffset, 10.0, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate != this;

  Offset getQuadraticBezierPoint(
      Offset start, Offset control, Offset end, double t) {
    final double x = pow(1 - t, 2) * start.dx +
        2 * (1 - t) * t * control.dx +
        pow(t, 2) * end.dx;

    final double y = pow(1 - t, 2) * start.dy +
        2 * (1 - t) * t * control.dy +
        pow(t, 2) * end.dy;

    return Offset(x, y);
  }
}
