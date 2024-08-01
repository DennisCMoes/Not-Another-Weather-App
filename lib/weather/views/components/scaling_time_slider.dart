import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:provider/provider.dart';

class ScalingTimeSlider extends StatefulWidget {
  final ValueChanged<DateTime> onChange;
  final ColorPair colorPair;

  const ScalingTimeSlider(
      {required this.onChange, required this.colorPair, super.key});

  @override
  State<ScalingTimeSlider> createState() => _ScalingTimeSliderState();
}

class _ScalingTimeSliderState extends State<ScalingTimeSlider> {
  late CurrentGeocodingProvider _geocodingProvider;

  @override
  void initState() {
    super.initState();

    _geocodingProvider =
        Provider.of<CurrentGeocodingProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPageChanged(DateTime time) {
    HapticFeedback.lightImpact();
    widget.onChange(time);
  }

  void _onTapOtherHour(DateTime time) {
    widget.onChange(time);

    int index = _geocodingProvider.get24hForecastIndex(time);
    _geocodingProvider.futureForecastController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        DateFormat hourFormat = DateFormat("HH:mm");
        List<MapEntry<DateTime, HourlyWeatherData>> futureForecast =
            state.get24hForecast();

        return PageView.builder(
          itemCount: futureForecast.length,
          controller: state.futureForecastController,
          onPageChanged: (value) => _onPageChanged(futureForecast[value].key),
          itemBuilder: (context, index) {
            HourlyWeatherData hourData = futureForecast[index].value;

            return AnimatedBuilder(
              animation: state.futureForecastController,
              builder: (context, child) {
                double value = 1.0;

                if (state.futureForecastController.position.haveDimensions) {
                  value = (state.futureForecastController.page ?? 0.0) - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                } else {
                  value = (index == 0) ? 1.0 : 0.7;
                }

                return Transform.scale(
                  scale: Curves.easeOut.transform(value),
                  child: child,
                );
              },
              child: Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(8),
                color: widget.colorPair.main.darkenColor(0.1),
                child: InkWell(
                  onTap: () => _onTapOtherHour(futureForecast[index].key),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${hourData.temperature.round()}º",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  color: widget.colorPair.accent
                                      .withOpacity(0.7))),
                      Text(hourFormat.format(futureForecast[index].key),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: widget.colorPair.accent)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
