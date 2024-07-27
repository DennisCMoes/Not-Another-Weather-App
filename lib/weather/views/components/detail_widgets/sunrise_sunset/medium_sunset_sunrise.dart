import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/painters/sun_painter.dart';

class MediumSunsetSunrise extends StatelessWidget {
  final Geocoding geocoding;

  const MediumSunsetSunrise({required this.geocoding, super.key});

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime? dateTime) {
      return dateTime == null
          ? "Invalid time"
          : DateFormat.Hm().format(dateTime);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Sunrise"),
                Text(
                  formatTime(geocoding.forecast?.sunrise),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sunset"),
                Text(
                  formatTime(geocoding.forecast?.sunset),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: SunPainter(currentTime: DateTime.now()),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
