import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

enum SelectableForecastFields {
  temperature("Temperature", Icons.thermostat),
  apparentTemperature("Apparent temperature", TablerIcons.user),
  windSpeed("Wind speed", TablerIcons.wind),
  precipitation("Precipitation", Icons.water_drop_outlined),
  chainceOfRain("Chance of rain", Icons.umbrella),
  sunrise("Sunrise", TablerIcons.sunrise),
  sunset("Sunset", TablerIcons.sunset),
  humidity("Humidity", Icons.percent),
  windDirection("Wind direction", TablerIcons.compass),
  windGusts("Wind gusts", Icons.speed),
  cloudCover("Cloud cover", TablerIcons.cloud),
  localTime("Local time", TablerIcons.clock);

  const SelectableForecastFields(this.label, this.icon);

  final String label;
  final IconData icon;

  static int fromEnumToIndex(SelectableForecastFields field) => field.index;

  static SelectableForecastFields fromIndexToEnum(int index) =>
      SelectableForecastFields.values[index];
}
