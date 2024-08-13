import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';

class ForecastSliderTrack extends SliderTrackShape {
  final int divisions = 24;
  final double trackPadding = 30.0;

  final ColorPair _colorPair;

  const ForecastSliderTrack(this._colorPair);

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

    // Time text section
    const double maxWidth = 40.0;
    const double verticalOffset = 10.0;

    final timeTextStyle = TextStyle(
      color: _colorPair.main.darkenColor(0.2),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final now = DateTime.now();
    // DateFormat

    TextSpan leftText = TextSpan(text: "NOW", style: timeTextStyle);
    TextSpan centerText = TextSpan(
        text: hourText(now.add(const Duration(hours: 12)).hour),
        style: timeTextStyle);
    TextSpan rightText = TextSpan(
        text: hourText(now.add(const Duration(hours: 24)).hour),
        style: timeTextStyle);

    TextPainter leftTextPainter =
        TextPainter(text: leftText, textDirection: textDirection);
    TextPainter centerTextPainter =
        TextPainter(text: centerText, textDirection: textDirection);
    TextPainter rightTextPainter =
        TextPainter(text: rightText, textDirection: textDirection);

    leftTextPainter.layout(minWidth: 0, maxWidth: maxWidth);
    centerTextPainter.layout(minWidth: 0, maxWidth: maxWidth);
    rightTextPainter.layout(minWidth: 0, maxWidth: maxWidth);

    final double verticalPosition = trackTop + trackHeight + verticalOffset;

    Offset leftOffset = Offset(
      trackLeft + trackPadding - (leftTextPainter.size.width / 2),
      verticalPosition,
    );
    Offset centerOffset = Offset(
      trackLeft + (trackWidth / 2) - (centerTextPainter.size.width / 2),
      verticalPosition,
    );
    Offset rightOffset = Offset(
      trackLeft + trackWidth - trackPadding - (rightTextPainter.size.width / 2),
      verticalPosition,
    );

    leftTextPainter.paint(context.canvas, leftOffset);
    centerTextPainter.paint(context.canvas, centerOffset);
    rightTextPainter.paint(context.canvas, rightOffset);
  }

  String hourText(int num) {
    return num.toString().padLeft(2, '0');
  }

  void paintHourText(
    Canvas canvas,
    TextDirection textDirection,
    String text,
    double xOffset,
  ) {
    const double maxWidth = 40.0;
    const double verticalOffset = 10.0;

    final timeTextStyle = TextStyle(
      color: _colorPair.main.darkenColor(0.2),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    TextSpan span = TextSpan(text: text, style: timeTextStyle);
    TextPainter textPainter =
        TextPainter(text: span, textDirection: textDirection);
    textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    Offset textOffset = Offset(xOffset, verticalOffset);

    textPainter.paint(canvas, textOffset);
  }
}
