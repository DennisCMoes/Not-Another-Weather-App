import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:not_another_weather_app/weather/views/painters/compass_painter.dart';
import 'package:provider/provider.dart';

class CompassWidget extends StatelessWidget {
  final WidgetSize size;

  const CompassWidget({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        switch (size) {
          case WidgetSize.small:
            return _small(context, state);
          case WidgetSize.medium:
            return _compass(context, state);
          case WidgetSize.large:
            return Row(
              children: [
                Expanded(child: _details(context, state)),
                Expanded(child: _compass(context, state)),
              ],
            );
        }
      },
    );
  }

  Widget _small(BuildContext context, CurrentGeocodingProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.directions),
        Text(
          "${provider.geocoding.forecast?.windDirection ?? "XX"}º",
          style: Theme.of(context).textTheme.displayMedium,
        )
      ],
    );
  }

  Widget _details(BuildContext context, CurrentGeocodingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Wind speed: ${provider.geocoding.forecast?.windSpeed.round() ?? 0.0}"),
        const Divider(),
        Text(
            "Wind gusts: ${provider.geocoding.forecast?.windGusts.round() ?? 0.0}"),
      ],
    );
  }

  Widget _compass(BuildContext context, CurrentGeocodingProvider provider) {
    return CustomPaint(
      painter: CompassPainter(
        angle: provider.geocoding.forecast?.windDirection.toDouble() ?? 0.0,
        ringColor:
            provider.geocoding.forecast?.weatherCode.colorScheme.accentColor ??
                Colors.white,
      ),
      child: Center(
        child: Text(
          "${provider.geocoding.forecast?.windDirection ?? "XX"}º",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: provider.geocoding.forecast?.weatherCode.colorScheme
                        .accentColor ??
                    Colors.white,
              ),
        ),
      ),
    );
  }
}
