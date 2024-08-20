import 'package:flutter/material.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/weather/weather_code.dart';
import 'package:not_another_weather_app/weather/views/components/summary_card_clipper.dart';
import 'package:provider/provider.dart';

class NoInternetScren extends StatefulWidget {
  const NoInternetScren({super.key});

  @override
  State<NoInternetScren> createState() => _NoInternetScrenState();
}

class _NoInternetScrenState extends State<NoInternetScren> {
  late WeatherProvider _weatherProvider;

  bool _isPressing = false;
  bool _isRefreshing = false;
  String _clipperText = "No internet";

  @override
  void initState() {
    super.initState();

    _weatherProvider = context.read<WeatherProvider>();
  }

  @override
  void dispose() {
    super.dispose();

    _weatherProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WeatherCode unknownWeather = WeatherCode.unknown;

    Future<void> refreshData() async {
      try {
        setState(() {
          _isRefreshing = true;
          _clipperText = "Refreshing";
        });

        await _weatherProvider.initializeForecastsOfGeocodings();
      } catch (exception) {
        // Wait at least one second for the user
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _isRefreshing = false;
          _clipperText = "No internet";
        });
      }
    }

    return ColoredBox(
      color: unknownWeather.colorScheme.getColorPair(true).main,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (details) => setState(() => _isPressing = true),
            onTapUp: (details) => setState(() => _isPressing = false),
            onTapCancel: () => setState(() => _isPressing = false),
            onTap: refreshData,
            child: Center(
              child: AnimatedScale(
                scale: _isPressing ? 0.95 : 1,
                duration: const Duration(milliseconds: 50),
                child: SummaryCardClipper(
                  clipper: unknownWeather.clipper.getClipper(),
                  colorPair: unknownWeather.colorScheme.getColorPair(true),
                  description: _clipperText,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isRefreshing
                    ? CircularProgressIndicator(
                        color: unknownWeather.colorScheme
                            .getColorPair(true)
                            .accent,
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.padding.bottom,
                    horizontal: 40,
                  ),
                  child: Text(
                    "Looks like you're not connected to the internet right now. Press on the circle to try again",
                    style: context.textTheme.displaySmall!.copyWith(
                      color:
                          unknownWeather.colorScheme.getColorPair(true).accent,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
