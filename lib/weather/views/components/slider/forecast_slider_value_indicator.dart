import 'package:flutter/material.dart';

class ForecastSliderValueIndicator extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(40);
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
    const double radius = 20.0;
    final double slideOffset = 30.0 * (1 - activationAnimation.value);
    final Offset circleCenter = Offset(center.dx, center.dy - 50 - slideOffset);

    final Paint paint = Paint()
      ..color = sliderTheme.valueIndicatorColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    context.canvas.drawCircle(circleCenter, radius + 5, paint);

    labelPainter.paint(
      context.canvas,
      circleCenter - Offset(labelPainter.width / 2, labelPainter.height / 2),
    );
  }
}
