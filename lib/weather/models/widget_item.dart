import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/compass/large_compass.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/compass/medium_compass.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/compass/small_compass.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/sunrise_sunset/large_sunset_sunrise.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/sunrise_sunset/medium_sunset_sunrise.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/sunrise_sunset/small_sunset_sunrise.dart';

enum WidgetSize {
  small(2, 1),
  medium(2, 2),
  large(4, 2);

  /// The amount of tiles the widget consumes in horizontal direction
  final int colSpan;

  /// The amount of tiles the widget consumes in vertical direction
  final int rowSpan;

  const WidgetSize(this.colSpan, this.rowSpan);

  @override
  String toString() => name;
}

enum WidgetType {
  compass(),
  sunriseSunset(),
  genericText();

  @override
  String toString() => name;
}

class WidgetItem {
  final int id;

  WidgetSize size;
  WidgetType type;

  WidgetItem({required this.id, required this.size, required this.type});

  Widget getWidget(Geocoding geocoding) {
    switch (type) {
      case WidgetType.compass:
        switch (size) {
          case WidgetSize.small:
            return SmallCompass(geocoding: geocoding);
          case WidgetSize.medium:
            return MediumCompass(geocoding: geocoding);
          case WidgetSize.large:
            return LargeCompass(geocoding: geocoding);
        }
      case WidgetType.sunriseSunset:
        switch (size) {
          case WidgetSize.small:
            return SmallSunsetSunrise(geocoding: geocoding);
          case WidgetSize.medium:
            return MediumSunsetSunrise(geocoding: geocoding);
          case WidgetSize.large:
            return LargeSunsetSunrise(geocoding: geocoding);
        }
      case WidgetType.genericText:
        return const Text("Generic");
    }
  }
}
