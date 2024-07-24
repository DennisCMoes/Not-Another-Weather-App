import 'package:flutter/material.dart';

final hours = List.generate(24, (index) => index);

class RainClass {
  final DateTime time;
  final int percentage;

  RainClass(this.time, this.percentage);
}

class LineChartPainter extends CustomPainter {
  late double _min, _max;
  late List<int> _y;
  late List<int> _x;

  final double radius = 4.0;

  final Paint linePaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final Paint dotPaintFill = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  final TextStyle yLabelStyle =
      const TextStyle(color: Colors.black, fontSize: 12);
  final TextStyle xLabelStyle =
      const TextStyle(color: Colors.black, fontSize: 12);

  LineChartPainter(Map<DateTime, int> percentages) {
    var min = double.maxFinite;
    var max = -double.maxFinite;

    for (var percentage in percentages.values) {
      min = min > percentage ? percentage.toDouble() : min;
      max = max < percentage ? percentage.toDouble() : max;
    }

    _min = min;
    _max = max;

    _y = List<int>.from(percentages.values);
    _x = List<int>.from(percentages.keys.map((time) => time.hour).toList());
  }

  List<Offset> _computePoints(Offset initialOffset, double boxWidth,
      double boxHeight, double heightRatio) {
    return _y.map((yPoint) {
      final adjustedY = boxHeight - (yPoint - _min) * heightRatio;
      final dataPoint = initialOffset + Offset(0, adjustedY);
      initialOffset += Offset(boxWidth, 0);
      return dataPoint;
    }).toList();
  }

  Path _computePath(List<Offset> points) {
    final path = Path();

    for (var i = 0; i < points.length; i++) {
      final point = points[i];

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    return path;
  }

  void _drawDataPoints(Canvas canvas, List<Offset> points, Paint dotPaintFill) {
    for (var dataPoint in points) {
      canvas.drawCircle(dataPoint, radius, dotPaintFill);
      canvas.drawCircle(dataPoint, radius, linePaint);
    }
  }

  List<String> _computeLabels() =>
      _y.map((yPoint) => yPoint.toStringAsFixed(1)).toList();

  void _drawYLabels(Canvas canvas, List<String> labels, List<Offset> points,
      double boxWidth, double topBoundary) {
    for (int i = 0; i < labels.length; i++) {
      final dataPoint = points[i];
      final verticalOffset = (dataPoint.dy - 15.0) < topBoundary ? 15.0 : -15.0;
      final labelPosition = dataPoint + Offset(0, verticalOffset);

      drawTextCentered(canvas, labelPosition, labels[i], yLabelStyle, boxWidth);
    }
  }

  void _drawXLabels(Canvas canvas, Offset currentOffset, double boxWidth) {
    for (var xLabel in _x) {
      drawTextCentered(
          canvas, currentOffset, xLabel.toString(), xLabelStyle, boxWidth);
      currentOffset += Offset(boxWidth, 0);
    }
  }

  TextPainter measureText(
      String text, TextStyle style, double maxWidth, TextAlign align) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
        text: textSpan, textAlign: align, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: maxWidth);
    return textPainter;
  }

  Size drawTextCentered(Canvas canvas, Offset center, String text,
      TextStyle style, double maxWidth) {
    final textPainter = measureText(text, style, maxWidth, TextAlign.center);
    final textOffset =
        center + Offset(-textPainter.width / 2.0, -textPainter.height / 2.0);
    textPainter.paint(canvas, textOffset);
    return textPainter.size;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const border = 2.0;

    // Calculate the drawable chart width and height
    final drawableHeight = size.height - 2.0 * border;
    final drawableWidth = size.width - 2.0 * border;

    final heightUnit = drawableHeight / 5.0;
    final widthUnit = drawableWidth / _x.length.toDouble();

    final boxHeight = heightUnit * 3.0;
    final boxWidth = widthUnit;

    // Escape if there are invalid values
    if (boxWidth <= 0.0 || boxHeight <= 0.0) return;
    if (_max - _min < 1.0e-6) return;

    final heightRatio = boxHeight / (_max - _min);
    final initialOffset = Offset(border + boxWidth / 2.0, border);
    final points =
        _computePoints(initialOffset, boxWidth, boxHeight, heightRatio);
    final path = _computePath(points);

    canvas.drawPath(path, linePaint);
    _drawDataPoints(canvas, points, dotPaintFill);

    final labels = _computeLabels();
    _drawYLabels(canvas, labels, points, boxWidth, border);

    final currentOffset =
        Offset(border + boxWidth / 2.0, border + 4.5 * heightUnit);
    _drawXLabels(canvas, currentOffset, boxWidth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      this != oldDelegate;
}
