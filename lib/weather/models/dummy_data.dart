import 'dart:math';

import 'package:not_another_weather_app/shared/extensions/list_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/daily_weather.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/hourly_weather.dart';
import 'package:not_another_weather_app/weather/models/weather/weather_code.dart';

class DummyData {
  static DateTime withOffset(int hours) =>
      DatetimeUtils.startOfHour().add(Duration(hours: hours));

  static HourlyWeatherData getRandomHourlyData(
    DateTime time,
    WeatherCode weatherCode,
  ) {
    Random random = Random();

    return HourlyWeatherData(
      time,
      random.nextInt(31) + 15,
      random.nextInt(31) + 15,
      random.nextInt(100) + 40,
      random.nextInt(100),
      num.parse((random.nextDouble() * 3).toStringAsFixed(2)).toDouble(),
      weatherCode.code,
      random.nextInt(100),
      num.parse((random.nextDouble() * 20).toStringAsFixed(2)).toDouble(),
      random.nextInt(360),
      num.parse((random.nextDouble() * 20).toStringAsFixed(2)).toDouble(),
    );
  }

  static DailyWeatherData getRandomDailyData(DateTime time) {
    Random random = Random();

    return DailyWeatherData(
      DatetimeUtils.startOfDay(time),
      time.add(const Duration(hours: -4)),
      time.add(const Duration(hours: 4)),
      random.nextDouble() * 5,
      random.nextDouble() * 5,
    );
  }

  static Geocoding colorSchemeGeocoding(TestClass testclass) {
    List<HourlyWeatherData> hourly = [];
    List<DailyWeatherData> daily = [];

    List<WeatherCode> uniqueWeatherCodes =
        WeatherCode.values.uniqueBy((code) => code.colorScheme);

    for (int i = 0; i < 48; i++) {
      int index = i % uniqueWeatherCodes.length;
      hourly.add(getRandomHourlyData(withOffset(i), uniqueWeatherCodes[index]));
    }

    for (int i = -1; i < 2; i++) {
      daily.add(getRandomDailyData(withOffset(i * 24)));
    }

    return Geocoding(11, "Color Scheme (${testclass.name})", 0, 0,
        "Color Scheme (${testclass.name})")
      ..isTestClass = testclass
      ..selectedForecastItems = SelectableForecastFields.values.take(4).toList()
      ..forecast = Forecast.withHourlyAndDaily(
          11, 11, "Europe/Amsterdam", 1, null, hourly, daily);
  }

  static Geocoding clipperGeocoding(TestClass testclass) {
    List<HourlyWeatherData> hourly = [];
    List<DailyWeatherData> daily = [];

    List<WeatherCode> uniqueByClipper =
        WeatherCode.values.uniqueBy((code) => code.clipper);

    for (int i = 0; i < 48; i++) {
      int index = i % uniqueByClipper.length;
      hourly.add(getRandomHourlyData(withOffset(i), uniqueByClipper[index]));
    }

    for (int i = -1; i < 2; i++) {
      daily.add(getRandomDailyData(withOffset(i * 24)));
    }

    return Geocoding(
        12, "Clipper (${testclass.name})", 0, 0, "Clipper (${testclass.name})")
      ..isTestClass = testclass
      ..selectedForecastItems = SelectableForecastFields.values.take(4).toList()
      ..forecast = Forecast.withHourlyAndDaily(
          11, 11, "Europe/Amsterdam", 1, null, hourly, daily);
  }
}
