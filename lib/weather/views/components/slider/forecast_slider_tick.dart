import 'package:flutter/material.dart';

class ForecastSliderTick extends RoundSliderTickMarkShape {
  @override
  Size getPreferredSize(
      {required SliderThemeData sliderTheme, required bool isEnabled}) {
    return const Size.fromRadius(1);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      required bool isEnabled,
      required TextDirection textDirection}) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    context.canvas.drawCircle(center, 1, paint);
  }
}
