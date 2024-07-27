import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

class SmallCompass extends StatelessWidget {
  final Geocoding geocoding;

  const SmallCompass({required this.geocoding, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.directions),
        Text(
          "${geocoding.forecast?.windDirection ?? "XX"}º",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ],
    );
  }
}
