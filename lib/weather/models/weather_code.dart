import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';
import 'package:not_another_weather_app/weather/views/clippers/circle_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/cloud_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/fog_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/rain_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/sun_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/tunderstorm_clipper.dart';

enum WeatherCode {
  // Sunny
  clearSky(0, "Clear Sky", WeatherColorScheme.clearAndSunny),

  // Cloudy
  mainlyClear(1, "Mainly clear", WeatherColorScheme.cloudy),
  partlyCloudy(2, "Partly clouded", WeatherColorScheme.partlyCloudyDay),
  overcast(3, "Overcast", WeatherColorScheme.overcast),

  // Fog
  fog(45, "Fog", WeatherColorScheme.fog),
  rimeFog(48, "Depositing rime fog", WeatherColorScheme.fog),

  // Drizzle
  lightDrizzle(51, "Light drizzle", WeatherColorScheme.rain),
  moderateDrizzle(53, "Moderate drizzle", WeatherColorScheme.rain),
  denseDrizzle(55, "Dense drizzle", WeatherColorScheme.rain),

  // Freezing drizzle
  lightFreezingDrizzle(
      56, "Light freezing drizzle", WeatherColorScheme.lightRain),
  heavyFreezingDrizzle(
      57, "Heavy freezing drizzle", WeatherColorScheme.lightRain),

  // Rain
  slightRain(61, "Slight rain", WeatherColorScheme.rain),
  moderateRain(63, "Moderate rain", WeatherColorScheme.rain),
  heavyRain(65, "Heavy rain", WeatherColorScheme.rain),

  // Freezing rain
  lighFreezingRain(66, "Light freezing rain", WeatherColorScheme.rain),
  heavyFreezingRain(67, "Heavy freezing rain", WeatherColorScheme.rain),

  // Snow
  slightSnowFall(71, "Slight snow fall", WeatherColorScheme.snow),
  moderateSnowFall(72, "Moderate snow fall", WeatherColorScheme.snow),
  heavySnowFall(73, "Heavy snow fall", WeatherColorScheme.snow),
  snowGrains(77, "Snow grains", WeatherColorScheme.snow),

  // Rain showers
  slightRainShower(80, "Slight rain shower", WeatherColorScheme.rain),
  moderateRainShower(81, "Moderate rain shower", WeatherColorScheme.rain),
  violentRainShower(82, "Violent rain shower", WeatherColorScheme.rain),

  // Snow showers
  slightSnowShower(85, "Slight snow shower", WeatherColorScheme.snow),
  heavySnowShower(86, "Heavy snow shower", WeatherColorScheme.snow),

  // Thunder
  slightOrModerateThunderstorm(
      95, "Thunderstorm", WeatherColorScheme.thunderstorm),
  slightThunderstormWithHail(
      96, "Thunderstorm", WeatherColorScheme.thunderstorm),
  moderateThunderstormWithHail(
      99, "Thunderstorm", WeatherColorScheme.thunderstorm),

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
