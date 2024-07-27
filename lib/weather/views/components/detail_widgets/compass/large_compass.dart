import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/painters/compass_painter.dart';

class LargeCompass extends StatelessWidget {
  final Geocoding geocoding;

  const LargeCompass({required this.geocoding, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Wind speed: ${geocoding.forecast?.windSpeed.round() ?? 0.0}"),
              const Divider(),
              Text(
                  "Wind gusts: ${geocoding.forecast?.windGusts.round() ?? 0.0}"),
            ],
          ),
        ),
        Expanded(
          child: CustomPaint(
            painter: CompassPainter(
              angle: geocoding.forecast?.windDirection.toDouble() ?? 0.0,
              ringColor:
                  geocoding.forecast?.weatherCode.colorScheme.accentColor ??
                      Colors.white,
            ),
            child: Center(
              child: Text(
                "${geocoding.forecast?.windDirection ?? "XX"}º",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
