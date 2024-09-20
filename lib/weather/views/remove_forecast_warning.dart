import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

class RemoveForecastWarning extends StatelessWidget {
  final Geocoding geocoding;

  const RemoveForecastWarning({super.key, required this.geocoding});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Ink(
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: Colors.red[200],
          ),
          child: IconButton(
            padding: const EdgeInsets.all(24),
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 78,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Remove this location?",
                textAlign: TextAlign.center,
                style: context.textTheme.displayMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              const Text(
                "This location will be removed from your list when you press on the trashcan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
