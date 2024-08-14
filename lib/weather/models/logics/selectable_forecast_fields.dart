import 'package:flutter/material.dart';

enum SelectableForecastFields {
  temperature("Temperature", Icons.thermostat),
  apparentTemperature("Apparent temperature", Icons.person),
  windSpeed("Wind speed", Icons.air),
  precipitation("Precipitation", Icons.water_drop),
  chainceOfRain("Chance of rain", Icons.umbrella),
  sunrise("Sunrise", Icons.keyboard_arrow_up),
  sunset("Sunset", Icons.keyboard_arrow_down),
  humidity("Humidity", Icons.percent),
  windDirection("Wind direction", Icons.directions),
  windGusts("Wind gusts", Icons.speed),
  cloudCover("Cloud cover", Icons.cloud),
  isDay("Day or night", Icons.access_time),
  localTime("Local time", Icons.circle);

  const SelectableForecastFields(this.label, this.icon);

  final String label;
  final IconData icon;

  static int fromEnumToIndex(SelectableForecastFields field) => field.index;

  static SelectableForecastFields fromIndexToEnum(int index) =>
      SelectableForecastFields.values[index];
}
