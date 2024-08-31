import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/views/clippers/circle_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/clear_day_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/clear_night_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/fog_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/overcast_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/partly_clouded_day.dart';
import 'package:not_another_weather_app/weather/views/clippers/partly_clouded_night.dart';
import 'package:not_another_weather_app/weather/views/clippers/rain_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/snow_clipper.dart';
import 'package:not_another_weather_app/weather/views/clippers/tunderstorm_clipper.dart';

enum WeatherClipper {
  clear,
  partlyClouded,
  overcast,
  fog,
  drizzle,
  rain,
  snow,
  thunder,
  unknown;

  CustomClipper<Path> getClipper([isDay = false]) {
    switch (this) {
      case WeatherClipper.clear:
        return isDay ? ClearDayClipper() : ClearNightClipper();
      case WeatherClipper.partlyClouded:
        return isDay ? PartlyCloudedDay() : PartlyCloudedNight();
      case WeatherClipper.overcast:
        return OvercastClipper();
      case WeatherClipper.fog:
        return FogClipper();
      case WeatherClipper.drizzle:
        return RainClipper();
      case WeatherClipper.rain:
        return RainClipper();
      case WeatherClipper.snow:
        return SnowClipper();
      case WeatherClipper.thunder:
        return ThunderstormClipper();
      case WeatherClipper.unknown:
        return CircleClipper();
    }
  }
}
