import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

class SmallSunsetSunrise extends StatelessWidget {
  final Geocoding geocoding;

  const SmallSunsetSunrise({required this.geocoding, super.key});

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime? dateTime) {
      return dateTime == null
          ? "Invalid time"
          : DateFormat.Hm().format(dateTime);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.keyboard_arrow_up, size: 32),
            Text(
              formatTime(geocoding.forecast?.sunrise),
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.keyboard_arrow_down, size: 32),
            Text(
              formatTime(geocoding.forecast?.sunset),
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ],
    );
  }
}
