import 'package:flutter/material.dart';
import 'package:weather/weather/models/colorscheme.dart';
import 'package:weather/weather/views/clippers/circle_clipper.dart';
import 'package:weather/weather/views/clippers/cloud_clipper.dart';
import 'package:weather/weather/views/clippers/fog_clipper.dart';
import 'package:weather/weather/views/clippers/rain_clipper.dart';
import 'package:weather/weather/views/clippers/snow_clipper.dart';
import 'package:weather/weather/views/clippers/sun_clipper.dart';
import 'package:weather/weather/views/clippers/tunderstorm_clipper.dart';

enum WeatherCode {
  // Sunny
  clearSky(0, "Clear Sky", WeatherColorScheme.dandelion),

  // Cloudy
  mainlyClear(1, "Mainly clear", WeatherColorScheme.gray),
  partlyCloudy(2, "Partly clouded", WeatherColorScheme.gray),
  overcast(3, "Overcast", WeatherColorScheme.gray),

  // Fog
  fog(45, "Fog", WeatherColorScheme.gray),
  rimeFog(46, "Depositing rime fog", WeatherColorScheme.gray),

  // Rain
  lightDrizzle(56, "Light freezing drizzle", WeatherColorScheme.cuttyShart),
  heavyDrizzle(57, "Heavy freezing drizzle", WeatherColorScheme.cuttyShart),
  slightRain(61, "Slight rain", WeatherColorScheme.cuttyShart),
  moderateRain(63, "Moderate rain", WeatherColorScheme.cuttyShart),
  heavyRain(65, "Heavy rain", WeatherColorScheme.cuttyShart),
  lighFreezingRain(66, "Light freezing rain", WeatherColorScheme.cuttyShart),
  heavyFreezingRain(67, "Heavy freezing rain", WeatherColorScheme.cuttyShart),

  // Snow
  slightSnowFall(71, "Slight snow fall", WeatherColorScheme.silver),
  moderateSnowFall(72, "Moderate snow fall", WeatherColorScheme.silver),
  heavySnowFall(73, "Heavy snow fall", WeatherColorScheme.silver),
  snowGrains(77, "Snow grains", WeatherColorScheme.silver),

  // Rain
  slightRainShower(80, "Slight rain shower", WeatherColorScheme.cuttyShart),
  moderateRainShower(81, "Moderate rain shower", WeatherColorScheme.cuttyShart),
  violentRainShower(82, "Violent rain shower", WeatherColorScheme.cuttyShart),

  // Snow
  slightSnowShower(85, "Slight snow shower", WeatherColorScheme.silver),
  heavySnowShower(86, "Heavy snow shower", WeatherColorScheme.silver),

  // Thunder
  thunderstorm(95, "Thunderstorm", WeatherColorScheme.gray),
  thunderstormWithHail(96, "Thunderstorm", WeatherColorScheme.gray),

  unknown(-1, "Something went wrong", WeatherColorScheme.gray);

  final int code;
  final String description;
  final WeatherColorScheme colorScheme;

  const WeatherCode(this.code, this.description, this.colorScheme);

  static WeatherCode fromCode(int code) {
    for (WeatherCode weather in WeatherCode.values) {
      if (weather.code == code) {
        return weather;
      }
    }

    return WeatherCode.unknown;
  }

  static CustomClipper<Path> getClipper(WeatherCode? code) {
    if (code == null) {
      return CircleClipper();
    }

    var sunnyCodes = [0];
    var cloudsCodes = [1, 2, 3];
    var fogCodes = [45, 46];
    var rainCodes = [56, 57, 61, 63, 65, 66, 67, 80, 81, 82];
    var snowCodes = [71, 72, 73, 77, 85, 86];
    var thunderCodes = [95, 96];

    if (sunnyCodes.contains(code.code)) {
      return SunClipper();
    } else if (cloudsCodes.contains(code.code)) {
      return CloudClipper();
    } else if (fogCodes.contains(code.code)) {
      return FogClipper();
    } else if (rainCodes.contains(code.code)) {
      return RainClipper();
    } else if (snowCodes.contains(code.code)) {
      return CircleClipper();
    } else if (thunderCodes.contains(code.code)) {
      return ThunderstormClipper();
    } else {
      return CircleClipper();
    }
  }
}
