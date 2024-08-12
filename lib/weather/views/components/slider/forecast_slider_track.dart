import 'package:flutter/material.dart';

class ForecastSliderTrack extends SliderTrackShape {
  final int divisions = 24;
  final double trackPadding = 30.0;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackWidth = parentBox.size.width - (trackPadding * 2);
    final double trackLeft = offset.dx + trackPadding;
    final double trackTop = (parentBox.size.height - trackHeight) / 2;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

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
    final Paint trackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final Paint divisionLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackWidth = parentBox.size.width;
    final double trackLeft = offset.dx;
    final double trackTop = (parentBox.size.height - trackHeight) / 2;

    final Rect trackRect =
        Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(16.0)),
      trackPaint,
    );

    final double divisionSpacing =
        (trackWidth - (trackPadding * 2)) / (divisions - 1);

    // for (int i = 0; i < divisions; i++) {
    //   final double divisionX = trackLeft + trackPadding + (i * divisionSpacing);

    //   context.canvas.drawLine(
    //     Offset(divisionX, trackTop),
    //     Offset(divisionX, trackTop + trackHeight),
    //     divisionLinePaint,
    //   );
    // }
  }
}
