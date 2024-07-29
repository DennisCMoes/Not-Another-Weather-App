import 'package:flutter/material.dart';

class HourSliderThumbShape extends SliderComponentShape {
  final double thumbWidth = 24.0;
  final double thumbHeight = 24.0;
  final double textPadding = 4.0;

  final int displayHour = 12;

  HourSliderThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: 10,
      height: thumbHeight,
    );

    final RRect roundedThumbRect = RRect.fromRectAndRadius(
      thumbRect,
      const Radius.circular(8),
    );

    context.canvas.drawRRect(roundedThumbRect, thumbPaint);

    final textSpan = TextSpan(
      text: displayHour.toString(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: textDirection)
      ..layout();

    final double textX = center.dx - (textPainter.width / 2);
    final double textY = center.dy - (textPainter.height / 2);

    // textPainter.paint(context.canvas, Offset(textX, textY));
  }
}
