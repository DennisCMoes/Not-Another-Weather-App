import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/compass_widget.dart';
import 'package:not_another_weather_app/weather/views/components/detail_widgets/sunrise_sunset_widget.dart';

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
        return CompassWidget(size: size);
      case WidgetType.sunriseSunset:
        return SunriseSunsetWidget(size: size);
      case WidgetType.genericText:
        return const Text("Generic");
    }
  }
}
