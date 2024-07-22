import 'dart:math';

import 'package:flutter/material.dart';

class PressureGaugePainter extends CustomPainter {
  final double pressure; // 950 to 1070 hpa

  PressureGaugePainter({required this.pressure});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint needlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final double radius = min(size.width / 2, size.height / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double gaugeRadius = radius * 0.9;

    const double tickLengthMinor = 10.0;
    const double tickLengthMajor = 20.0;

    drawPressureLevel(canvas, center, size);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(-pi * 2 / 4);
    canvas.translate(-center.dx, -center.dy);

    // Draw the arc
    paint.strokeWidth = 4.0;
    paint.style = PaintingStyle.stroke;
    Rect rect = Rect.fromCircle(center: center, radius: gaugeRadius);
    canvas.drawArc(rect, -pi * 3 / 4, pi * 1.5, false, paint);

    // Draw gauge ticks and labels
    const double minPressure = 950.0;
    const double maxPressure = 1070.0;
    const double pressureRange = maxPressure - minPressure;
    const double tickSpacing = 5.0;

    for (double pressureLevel = minPressure;
        pressureLevel <= maxPressure;
        pressureLevel += tickSpacing) {
      double pressureNormalized = (pressureLevel - minPressure) / pressureRange;
      double angle = -pi * 3 / 4 + pressureNormalized * pi * 1.5;

      double tickLength = (pressureLevel % (tickSpacing * 5) == 0
          ? tickLengthMajor
          : tickLengthMinor);

      final double startX = center.dx + (gaugeRadius - tickLength) * cos(angle);
      final double startY = center.dy + (gaugeRadius - tickLength) * sin(angle);

      final double endX = center.dx + gaugeRadius * cos(angle);
      final double endY = center.dy + gaugeRadius * sin(angle);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Draw the needle
    final double needleLength = gaugeRadius;
    final double pressureNormalized = (pressure - minPressure) / pressureRange;
    final double needleAngle = pressureNormalized * pi;

    final double needleX = center.dx + needleLength * cos(needleAngle);
    final double needleY = center.dy + needleLength * sin(needleAngle);

    canvas.drawLine(center, Offset(needleX, needleY), needlePaint);
  }

  void drawPressureLevel(Canvas canvas, Offset center, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: pressure.round().toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    Offset position = Offset(
        (center.dx / 2) + (textPainter.size.width / 2), size.height * 0.7);
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate != this;
}
