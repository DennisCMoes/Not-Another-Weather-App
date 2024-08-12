import 'package:flutter/material.dart';

class ForecastSliderOverlay extends SliderComponentShape {
  final double overlayRadius = 24.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(overlayRadius);
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
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final double animatedRadius = overlayRadius * activationAnimation.value;
    final double offsetY = 50.0 * (1.0 - activationAnimation.value);

    final Offset overlayOffset = Offset(center.dx, center.dy - offsetY);

    context.canvas.drawCircle(overlayOffset, 25, paint);

    labelPainter.paint(
      context.canvas,
      Offset(
        overlayOffset.dx - (labelPainter.width / 2),
        overlayOffset.dy - (labelPainter.height / 2),
      ),
    );
  }
}
