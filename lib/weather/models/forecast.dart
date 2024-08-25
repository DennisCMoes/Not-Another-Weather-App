import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/menu/models/units.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/daily_weather.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/hourly_weather.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Entity()
class Forecast {
  late SharedPreferences _preferences;

  @Id(assignable: true)
  int id = 0;

  double latitude;
  double longitude;
  String timezome;
  double pressure;

  @Backlink('forecast')
  List<HourlyWeatherData> hourlyWeatherList = [];
  @Backlink('forecast')
  List<DailyWeatherData> dailyWeatherDataList = [];

  Map<DateTime, HourlyWeatherData> get hourlyWeatherData =>
      {for (var e in hourlyWeatherList) e.time: e};
  Map<DateTime, DailyWeatherData> get dailyWeatherData =>
      {for (var e in dailyWeatherDataList) e.time: e};

  Forecast(
    this.latitude,
    this.longitude,
    this.timezome,
    this.pressure,
  ) {
    SharedPreferences.getInstance().then((value) => _preferences = value);
  }

  factory Forecast.fromJson(Map<String, dynamic> json) {
    DateFormat hourFormat = DateFormat('yyyy-MM-ddTHH:mm');
    DateFormat dayFormat = DateFormat("yyyy-MM-dd");

    List<DateTime> times = List<String>.from(json['hourly']['time'])
        .map((time) => hourFormat.parseUtc(time))
        .toList();

    List<DateTime> days = List<String>.from(json['daily']['time'])
        .map((day) => dayFormat.parseUtc(day))
        .toList();

    var dataMap = _extractDataMap(json['hourly']);
    var daysMap = _extractDataMap(json['daily']);

    List<HourlyWeatherData> hourlyWeatherData = [];
    List<DailyWeatherData> dailyWeatherData = [];

    Forecast forecast = Forecast(
      json['latitude'],
      json['longitude'],
      json['timezone'],
      json['current']['surface_pressure'],
    );

    for (int i = 0; i < times.length; i++) {
      HourlyWeatherData hourly = HourlyWeatherData(
        times[i],
        dataMap['temperature_2m']![i],
        dataMap['apparent_temperature']![i],
        dataMap['relative_humidity_2m']![i],
        dataMap['precipitation_probability']![i],
        dataMap['precipitation']![i],
        dataMap['weather_code']![i],
        dataMap['cloud_cover']![i],
        dataMap['wind_speed_10m']![i],
        dataMap['wind_direction_10m']![i],
        dataMap['wind_gusts_10m']![i],
      );

      hourly.forecast.target = forecast;
      hourlyWeatherData.add(hourly);
    }

    for (int i = 0; i < days.length; i++) {
      DailyWeatherData daily = DailyWeatherData(
        days[i],
        hourFormat.parseUtc(daysMap['sunrise']![i]),
        hourFormat.parseUtc(daysMap['sunset']![i]),
        daysMap['uv_index_max']![i],
        daysMap['uv_index_clear_sky_max']![i],
      );

      daily.forecast.target = forecast;
      dailyWeatherData.add(daily);
    }

    return forecast
      ..dailyWeatherDataList = dailyWeatherData
      ..hourlyWeatherList = hourlyWeatherData;
  }

  static Map<String, List<dynamic>> _extractDataMap(Map<String, dynamic> data) {
    return data.map((key, value) =>
        MapEntry(key, key == 'time' ? [] : List<dynamic>.from(value)));
  }

  HourlyWeatherData getCurrentHourData([DateTime? date]) {
    date ??= DatetimeUtils.convertToTimezone(DateTime.now(), timezome);

    if (hourlyWeatherList.isEmpty) {
      return HourlyWeatherData.noInternet(date);
    } else if (date.isAfter(hourlyWeatherList.last.time) ||
        date.isBefore(hourlyWeatherList.first.time)) {
      return HourlyWeatherData.noInternet(date);
    } else {
      return hourlyWeatherData[DatetimeUtils.startOfHour(date)]!;
    }
  }

  DailyWeatherData getCurrentDayData([DateTime? date]) {
    date ??= DatetimeUtils.startOfDay(DatetimeUtils.startOfHour());

    if (hourlyWeatherList.isEmpty) {
      return DailyWeatherData.invalidDay(date);
    } else if (date.isAfter(hourlyWeatherList.last.time) ||
        date.isBefore(hourlyWeatherList.first.time)) {
      return DailyWeatherData.invalidDay(date);
    } else {
      DateTime startOfDay = DatetimeUtils.startOfDay(date);
      return dailyWeatherData[startOfDay]!;
    }
  }

  dynamic getField(SelectableForecastFields field, [DateTime? date]) {
    DateFormat hourFormat = DateFormat("HH:mm");

    HourlyWeatherData currentHourData = getCurrentHourData(date);
    DailyWeatherData currentDayData = getCurrentDayData(date);

    // int windSpeedUnit = _preferences.getInt("wind_speed_unit") ?? 0;
    // int precipitationUnit = _preferences.getInt("precipitation_unit") ?? 0;
    int windSpeedUnit = 0;
    int precipitationUnit = 0;

    if (currentHourData.invalidData || currentDayData.invalidData) {
      return "XX";
    }

    switch (field) {
      case SelectableForecastFields.temperature:
        return "${currentHourData.temperature.round()}º";
      case SelectableForecastFields.apparentTemperature:
        return "${currentHourData.apparentTemperature.round()}º";
      case SelectableForecastFields.windSpeed:
        String label = WindspeedUnit.values[windSpeedUnit].label.toLowerCase();

        return "${currentHourData.windSpeed.round()}$label";
      case SelectableForecastFields.precipitation:
        String label = PrecipitationUnit.values[precipitationUnit].value;

        return "${currentHourData.rainInMM}$label";
      case SelectableForecastFields.chainceOfRain:
        return "${currentHourData.rainProbability}%";
      case SelectableForecastFields.sunrise:
        return hourFormat.format(currentDayData.sunrise);
      case SelectableForecastFields.sunset:
        return hourFormat.format(currentDayData.sunset);
      case SelectableForecastFields.humidity:
        return "${currentHourData.humidity}%";
      case SelectableForecastFields.windDirection:
        return "${currentHourData.windDirection}º";
      case SelectableForecastFields.windGusts:
        return "${currentHourData.windGusts.round()}km/h";
      case SelectableForecastFields.cloudCover:
        return "${currentHourData.cloudCover}%";
      case SelectableForecastFields.localTime:
        final convertedTime =
            DatetimeUtils.convertToTimezone(DateTime.now(), timezome);
        return hourFormat.format(convertedTime);
      default:
        return "Unknown";
    }
  }

  CustomClipper<Path> getClipperOfHour(DateTime date) {
    HourlyWeatherData hourlyWeatherData = getCurrentHourData(date);
    DailyWeatherData dailyWeatherData = getCurrentDayData(date);

    bool isBeforeSunset = date.isBefore(dailyWeatherData.sunset) ||
        date.isAtSameMomentAs(dailyWeatherData.sunset);
    bool isAfterSunrise = date.isAfter(dailyWeatherData.sunrise) ||
        date.isAtSameMomentAs(dailyWeatherData.sunrise);

    bool isInTheDay = isBeforeSunset && isAfterSunrise;

    return hourlyWeatherData.weatherCode.clipper.getClipper(isInTheDay);
  }

  ColorPair getColorPair([DateTime? date]) {
    date ??= DateTime.now();

    DailyWeatherData daily = getCurrentDayData(date);
    HourlyWeatherData hourly = getCurrentHourData(date);

    final isBeforeSunset = date.isBefore(daily.sunset);
    final isAfterSunrise = date.isAfter(daily.sunrise);

    final isInTheDay = isAfterSunrise && isBeforeSunset;
    return hourly.weatherCode.colorScheme.getColorPair(isInTheDay);
  }

  static Forecast isLoadingData() {
    List<DateTime> days =
        List.generate(3, (index) => DateTime.now().add(Duration(days: index)));
    List<DateTime> hours = List.generate(
        24, (index) => DateTime.now().add(Duration(hours: index)));

    return Forecast(20, 20, "Europe/Amsterdam", 20)
      ..dailyWeatherDataList =
          days.map((day) => DailyWeatherData.invalidDay(day)).toList()
      ..hourlyWeatherList =
          hours.map((hour) => HourlyWeatherData.isLoading(hour)).toList();
  }

  static Forecast noInternet() {
    List<DateTime> hours = List.generate(
        24, (index) => DateTime.now().add(Duration(hours: index)));

    return Forecast(20, 20, "Europe/Amsterdam", 20)
      ..dailyWeatherDataList = []
      ..hourlyWeatherList =
          hours.map((hour) => HourlyWeatherData.noInternet(hour)).toList();
  }

  @override
  String toString() {
    return "${getCurrentHourData().temperature}º - [$latitude|$longitude] - ${getCurrentHourData().weatherCode.description}";
  }
}
