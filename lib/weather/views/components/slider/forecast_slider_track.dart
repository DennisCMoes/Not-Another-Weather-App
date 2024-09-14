import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';

class ForecastSliderTrack extends SliderTrackShape {
  final int divisions = 24;
  final double trackPadding = 30.0;

  final Color _textColor;
  final DateTime _now;

  const ForecastSliderTrack(this._now, this._textColor);

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

    final Paint hourLinePaint = Paint()
      ..color = sliderTheme.activeTrackColor!.darkenColor(0.1)
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
    const double verticalOffset = 10.0;
    final double textVerticalPosition = trackTop + trackHeight + verticalOffset;

    final slidableTrackWidth = trackWidth - (trackPadding * 2);
    final slidableTrackLeft = trackLeft + trackPadding;

    final Map<String, double> textLabels = {
      "NOW": slidableTrackLeft,
      hourText(_now.add(const Duration(hours: 6)).hour):
          slidableTrackLeft + (slidableTrackWidth / 4),
      hourText(_now.add(const Duration(hours: 12)).hour):
          slidableTrackLeft + (slidableTrackWidth / 2),
      hourText(_now.add(const Duration(hours: 18)).hour):
          slidableTrackLeft + ((slidableTrackWidth / 4) * 3),
      hourText(_now.add(const Duration(hours: 24)).hour):
          slidableTrackLeft + slidableTrackWidth,
    };

    for (var label in textLabels.entries) {
      paintHourText(
        context.canvas,
        textDirection,
        label.key,
        label.value,
        textVerticalPosition,
      );
    }

    for (int i = 0; i < 25; i++) {
      drawHourLine(
        context.canvas,
        hourLinePaint,
        slidableTrackLeft + (slidableTrackWidth / 24) * i,
        thumbCenter.dy,
        i % 6 == 0 ? 16.0 : 8.0,
      );
    }
  }

  String hourText(int num) {
    return num.toString().padLeft(2, '0');
  }

  void drawHourLine(Canvas canvas, Paint paint, double xOffset, double yOffset,
      double height) {
    Rect hourLineRect = Rect.fromCenter(
        center: Offset(xOffset, yOffset), width: 2, height: height);

    canvas.drawRRect(
      RRect.fromRectAndRadius(hourLineRect, const Radius.circular(8)),
      paint,
    );
  }

  void paintHourText(
    Canvas canvas,
    TextDirection textDirection,
    String text,
    double xOffset,
    double yOffset,
  ) {
    const double maxWidth = 40.0;

    final timeTextStyle = TextStyle(
      color: _textColor.darkenColor(0.2),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    TextSpan span = TextSpan(text: text, style: timeTextStyle);
    TextPainter textPainter =
        TextPainter(text: span, textDirection: textDirection);
    textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    Offset textOffset = Offset(xOffset - (textPainter.size.width / 2), yOffset);

    textPainter.paint(canvas, textOffset);
  }
}
