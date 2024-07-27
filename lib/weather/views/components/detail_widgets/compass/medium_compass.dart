import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/painters/compass_painter.dart';

class MediumCompass extends StatelessWidget {
  final Geocoding geocoding;

  const MediumCompass({required this.geocoding, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CompassPainter(
        angle: geocoding.forecast?.windDirection.toDouble() ?? 0.0,
        ringColor: geocoding.forecast?.weatherCode.colorScheme.accentColor ??
            Colors.white,
      ),
      child: Center(
        child: Text(
          "${geocoding.forecast?.windDirection ?? "XX"}º",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
