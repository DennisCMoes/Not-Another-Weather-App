import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:not_another_weather_app/weather/views/painters/sun_painter.dart';
import 'package:provider/provider.dart';

class SunriseSunsetWidget extends StatelessWidget {
  final WidgetSize size;

  const SunriseSunsetWidget({required this.size, super.key});

  String formatTime(DateTime? dateTime) {
    return dateTime == null ? "Invalid time" : DateFormat.Hm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        if (size == WidgetSize.small) {
          return _small(context, state);
        } else {
          return _sunDetails(context, state);
        }
      },
    );
  }

  Widget _small(BuildContext context, CurrentGeocodingProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.keyboard_arrow_up),
            Text(formatTime(provider.geocoding.forecast?.sunrise)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.keyboard_arrow_down),
            Text(formatTime(provider.geocoding.forecast?.sunset)),
          ],
        )
      ],
    );
  }

  Widget _sunDetails(BuildContext context, CurrentGeocodingProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Sunrise"),
                Text(formatTime(provider.geocoding.forecast?.sunrise)),
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
                Text(formatTime(provider.geocoding.forecast?.sunset)),
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
