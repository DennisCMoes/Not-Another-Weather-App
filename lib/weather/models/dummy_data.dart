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
      random.nextDouble() * 3,
      weatherCode,
      random.nextInt(100),
      random.nextDouble() * 20,
      random.nextInt(360),
      random.nextDouble() * 20,
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

  static Geocoding colorSchemeGeocoding() {
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

    Geocoding geocoding = Geocoding(11, "Color Scheme", 0, 0, "Color Scheme")
      ..isTestClass = true
      ..selectedForecastItems = SelectableForecastFields.values.take(4).toList()
      ..forecast = Forecast(
        11,
        11,
        "Europe/Amsterdam",
        1,
        hourly,
        daily,
      );

    return geocoding;
  }
}
