import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';
import 'package:not_another_weather_app/weather/views/painters/compass_painter.dart';
import 'package:provider/provider.dart';

class CompassWidget extends StatelessWidget {
  final WidgetSize size;

  const CompassWidget({required this.size, super.key});

  String getHeading([int heading = 0]) {
    if (heading >= 0 && heading <= 22.5 && heading >= 337.5) {
      return "N";
    } else if (heading > 22.5 && heading <= 67.5) {
      return "NE";
    } else if (heading > 67.5 && heading <= 112.5) {
      return "E";
    } else if (heading > 112.5 && heading <= 157.5) {
      return 'SE';
    } else if (heading > 157.5 && heading <= 202.5) {
      return 'S';
    } else if (heading > 202.5 && heading <= 247.5) {
      return 'SW';
    } else if (heading > 247.5 && heading <= 292.5) {
      return 'W';
    } else if (heading > 292.5 && heading <= 337.5) {
      return 'NW';
    } else {
      return 'XX';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        HourlyWeatherData? weatherData =
            state.geocoding.forecast?.getCurrentHourData(state.selectedHour);

        switch (size) {
          case WidgetSize.small:
            return _small(context, state, weatherData);
          case WidgetSize.medium:
            return _compass(context, state, weatherData);
          case WidgetSize.large:
            return Row(
              children: [
                Expanded(child: _details(context, state, weatherData)),
                Expanded(child: _compass(context, state, weatherData)),
              ],
            );
        }
      },
    );
  }

  Widget _small(BuildContext context, CurrentGeocodingProvider provider,
      HourlyWeatherData? weatherData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.directions),
        Text(
          "${weatherData?.windDirection ?? "XX"}º",
          style: Theme.of(context).textTheme.displayMedium,
        )
      ],
    );
  }

  Widget _details(BuildContext context, CurrentGeocodingProvider provider,
      HourlyWeatherData? weatherData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Wind speed"),
              Text("${weatherData?.windSpeed.round() ?? 0.0} km/h",
                  style: Theme.of(context).textTheme.displayMedium),
            ],
          ),
          Divider(
            color: provider.getWeatherColorScheme().accent,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${weatherData?.windGusts.round() ?? 0.0} km/h",
                  style: Theme.of(context).textTheme.displayMedium),
              const Text("Wind gusts")
            ],
          ),
        ],
      ),
    );
  }

  Widget _compass(BuildContext context, CurrentGeocodingProvider provider,
      HourlyWeatherData? weatherData) {
    return CustomPaint(
      painter: CompassPainter(
          direction: weatherData?.windDirection.toDouble() ?? 0.0,
          colorPair: provider.getWeatherColorScheme()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            getHeading(weatherData?.windDirection ?? 0),
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: provider.getWeatherColorScheme().accent),
          ),
        ],
      ),
    );
  }
}
