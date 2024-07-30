import 'dart:math';

import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';

/// A custom painter for drawing a compass with a needle indicating a direction
class CompassPainter extends CustomPainter {
  final double direction;
  final ColorPair colorPair;

  CompassPainter({required this.direction, required this.colorPair});

  double get rotation => -2 * pi * (direction / 360);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = colorPair.main.darkenColor(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint needlePaint = Paint()
      ..color = colorPair.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint endCirclePaint = Paint()
      ..color = colorPair.main.darkenColor(0.05)
      ..style = PaintingStyle.fill;

    final Paint tickPaint = Paint()
      ..color = colorPair.main.darkenColor(0.2)
      ..strokeWidth = 1.5;

    final Paint needleCirclePaint = Paint()
      ..color = colorPair.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint needleArrowheadPaint = Paint()
      ..color = colorPair.accent
      ..style = PaintingStyle.fill;

    double radius = min(size.width / 2.2, size.height / 2.2);
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the compass circle
    canvas.drawCircle(center, radius, circlePaint);

    // Draw ticks for every 30 degrees and shorter ticks for every 10 degrees
    for (double angle = 0; angle < 360; angle += 10) {
      final double tickLength = angle % 30 == 0 ? 10 : 5;
      final Offset startTick =
          _calculatePoint(center, radius - tickLength, angle);
      final Offset endTick = _calculatePoint(center, radius, angle);

      canvas.drawLine(startTick, endTick, tickPaint);
    }

    // Draw cardinal directions
    _drawCardinalDirection(canvas, center, 'N', Offset(0, -radius + 20));
    _drawCardinalDirection(canvas, center, 'E', Offset(radius - 20, 0));
    _drawCardinalDirection(canvas, center, 'S', Offset(0, radius - 20));
    _drawCardinalDirection(canvas, center, 'W', Offset(-radius + 20, 0));

    // Draw the needle
    final Offset needleStart =
        _calculatePoint(center, radius - 12, direction + 180);
    final Offset needleEnd = _calculatePoint(center, radius - 27, direction);
    canvas.drawLine(needleStart, needleEnd, needlePaint);

    // Draw the end circle
    const double endCircleRadius = 7;
    final Offset endCircleCenter =
        _calculatePoint(center, radius - endCircleRadius - 15, direction);
    canvas.drawCircle(endCircleCenter, endCircleRadius, needleCirclePaint);

    // Draw the arrowhead
    final Offset arrowheadPoint =
        _calculatePoint(center, radius - 10, direction + 180);
    canvas.drawPath(_calculateArrowHeadPath(arrowheadPoint, direction),
        needleArrowheadPaint);

    canvas.drawCircle(center, 40, endCirclePaint);
  }

  /// Calculates a point on the circumference of a circle
  ///
  /// [center] is the center of the circle
  /// [radius] is the radius of the circle
  /// [angle] is the angle in degrees from the positive x-axis
  Offset _calculatePoint(Offset center, double radius, double angle) {
    final adjustedDirection = angle - 90;
    final radians = adjustedDirection * (pi / 180);

    final xCor = center.dx + radius * cos(radians);
    final yCor = center.dy + radius * sin(radians);

    return Offset(xCor, yCor);
  }

  /// Draws a cardinal direction label on the canvas
  ///
  /// [canvas] is the canvas to draw on
  /// [center] is the center of the compass
  /// [label] is the direction label (e.g., 'N', 'E', 'S', 'W')
  /// [offset] is the position offset for the label
  void _drawCardinalDirection(
      Canvas canvas, Offset center, String direction, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: direction,
        style: TextStyle(
          color: colorPair.accent.withOpacity(0.6),
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

  /// Draws an arrowhead at a given point on the canvas
  ///
  /// [canvas] is the canvas to draw on
  /// [point] is the point where the arrowhead is drawn
  /// [angle] is the direction angle of the arrowhead in degrees
  Path _calculateArrowHeadPath(Offset point, double angle) {
    const arrowSize = 15.0;
    const arrowAngle = pi / 6; // 30 degrees

    final path = Path();
    final adjustedDirection = angle - 90;
    final radians = adjustedDirection * (pi / 180);

    // Calculate the points for the arrowhead triangle
    final leftPoint = Offset(
      point.dx + arrowSize * cos(radians + arrowAngle),
      point.dy + arrowSize * sin(radians + arrowAngle),
    );

    final rightPoint = Offset(
      point.dx + arrowSize * cos(radians - arrowAngle),
      point.dy + arrowSize * sin(radians - arrowAngle),
    );

    path.moveTo(point.dx, point.dy);
    path.lineTo(leftPoint.dx, leftPoint.dy);
    path.lineTo(rightPoint.dx, rightPoint.dy);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate != this;
}
