import 'package:flutter/material.dart';

class HourSliderTrackShape extends SliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    const double trackHeight = 24;

    final Paint trackPaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.white12
      ..style = PaintingStyle.fill;

    final Rect trackRect = Rect.fromCenter(
      center: Offset(parentBox.size.width / 2, parentBox.size.height / 2),
      width: parentBox.size.width,
      height: trackHeight,
    );

    final RRect roundedTrackRect =
        RRect.fromRectAndRadius(trackRect, const Radius.circular(4));

    context.canvas.drawRRect(roundedTrackRect, trackPaint);
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(
        trackLeft + 12, trackTop, trackWidth - 24, trackHeight);
  }
}
