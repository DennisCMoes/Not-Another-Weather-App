import 'package:flutter/material.dart';

enum WeatherCode {
  // Sunny
  clearSky(0, "Clear Sky", Color(0xFF87CEEB)),

  // Cloudy
  mainlyClear(1, "Mainly clear", Color(0xFFB0E0E6)),
  partlyCloudy(2, "Partly clouded", Color(0xFFC0C0C0)),
  overcast(3, "Overcast", Color(0xFFA9A9A9)),

  // Fog
  fog(45, "Fog", Color(0xFFD3D3D3)),
  rimeFog(46, "Depositing rime fog", Color(0xFFD3D3D3)),

  // Rain
  lightDrizzle(56, "Light freezing drizzle", Color(0xFFB0C4DE)),
  heavyDrizzle(57, "Heavy freezing drizzle", Color(0xFF4682B4)),
  slightRain(61, "Slight rain", Color(0xFFADD8E6)),
  moderateRain(63, "Moderate rain", Color(0xFF87CEEB)),
  heavyRain(65, "Heavy rain", Color(0xFF4682B4)),
  lighFreezingRain(66, "Light freezing rain", Color(0xFFB0C4DE)),
  heavyFreezingRain(67, "Heavy freezing rain", Color(0xFF4682B4)),

  // Snow
  slightSnowFall(71, "Slight snow fall", Color(0xFFFFFFFF)),
  moderateSnowFall(72, "Moderate snow fall", Color(0xFFF0F8FF)),
  heavySnowFall(73, "Heavy snow fall", Color(0xFFE0FFFF)),
  snowGrains(77, "Snow grains", Color(0xFFAFEEEE)),

  // Rain
  slightRainShower(80, "Slight rain shower", Color(0xFFADD8E6)),
  moderateRainShower(81, "Moderate rain shower", Color(0xFF87CEEB)),
  violentRainShower(82, "Violent rain shower", Color(0xFF4682B4)),

  // Snow
  slightSnowShower(85, "Slight snow shower", Color(0xFFF0F8FF)),
  heavySnowShower(86, "Heavy snow shower", Color(0xFFE0FFFF)),

  // Thunder
  thunderstorm(95, "Thunderstorm", Color(0xFF808080)),
  thunderstormWithHail(96, "Thunderstorm", Color(0xFF696969)),

  unknown(-1, "Something went wrong", Color(0xFFFF0000));

  final int code;
  final String description;
  final Color color;

  const WeatherCode(this.code, this.description, this.color);

  static WeatherCode fromCode(int code) {
    for (WeatherCode weather in WeatherCode.values) {
      if (weather.code == code) {
        return weather;
      }
    }

    return WeatherCode.unknown;
  }
}
