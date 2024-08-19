import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/logics/widget_item.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/daily_weather.dart';
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
    return Consumer<ForecastCardProvider>(
      builder: (context, state, child) => FutureBuilder(
        future: state.geocoding.forecast,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final forecast = snapshot.data!;
            final weatherData = forecast.getCurrentDayData(state.selectedHour);
            final colorPair = forecast.getColorPair(state.selectedHour);

            if (size == WidgetSize.small) {
              return _small(context, weatherData);
            } else {
              return _sunDetails(context, colorPair, weatherData);
            }
          }
        },
      ),
    );
  }

  Widget _small(BuildContext context, DailyWeatherData weatherData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.keyboard_arrow_up),
            Text(formatTime(weatherData.sunrise)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.keyboard_arrow_down),
            Text(formatTime(weatherData.sunset)),
          ],
        )
      ],
    );
  }

  Widget _sunDetails(
      BuildContext context, ColorPair colorPair, DailyWeatherData weatherData) {
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
                Text(
                  formatTime(weatherData.sunrise),
                  style: context.textTheme.displaySmall,
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
                  formatTime(weatherData.sunset),
                  style: context.textTheme.displaySmall,
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: SunPainter(
              currentTime: DateTime.now(),
              colorPair: colorPair,
            ),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
