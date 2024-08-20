import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/models/weather/weather_code.dart';
import 'package:not_another_weather_app/weather/views/components/summary_card_clipper.dart';

class NoInternetScren extends StatefulWidget {
  final Function refresh;

  const NoInternetScren({super.key, required this.refresh});

  @override
  State<NoInternetScren> createState() => _NoInternetScrenState();
}

class _NoInternetScrenState extends State<NoInternetScren> {
  bool _isPressing = false;

  @override
  Widget build(BuildContext context) {
    WeatherCode unknownWeather = WeatherCode.unknown;

    return ColoredBox(
      color: unknownWeather.colorScheme.getColorPair(true).main,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (details) => setState(() => _isPressing = true),
            onTapUp: (details) => setState(() => _isPressing = false),
            onTapCancel: () => setState(() => _isPressing = false),
            onTap: () => widget.refresh(),
            child: Center(
              child: AnimatedScale(
                scale: _isPressing ? 0.95 : 1,
                duration: const Duration(milliseconds: 50),
                child: SummaryCardClipper(
                  clipper: unknownWeather.clipper.getClipper(),
                  colorPair: unknownWeather.colorScheme.getColorPair(true),
                  description: "No internet",
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.padding.bottom,
                horizontal: 40,
              ),
              child: Text(
                "Looks like you're not connected to the internet right now. Press on the circle to try again",
                style: context.textTheme.displaySmall!.copyWith(
                  color: unknownWeather.colorScheme.getColorPair(true).accent,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
