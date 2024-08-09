import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:instant/instant.dart';
import 'package:not_another_weather_app/menu/models/units.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HourlyWeatherData {
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final int rainProbability;
  final double rainInMM;
  final WeatherCode weatherCode;
  final int cloudCover;
  final double windSpeed;
  final int windDirection;
  final double windGusts;

  HourlyWeatherData(
      this.temperature,
      this.apparentTemperature,
      this.humidity,
      this.rainProbability,
      this.rainInMM,
      this.weatherCode,
      this.cloudCover,
      this.windSpeed,
      this.windDirection,
      this.windGusts);
}

class DailyWeatherData {
  final DateTime sunrise;
  final DateTime sunset;
  final double uvIndex;
  final double clearSkyUvIndex;

  DailyWeatherData(
      this.sunrise, this.sunset, this.uvIndex, this.clearSkyUvIndex);
}

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

class Forecast {
  late SharedPreferences _preferences;

  double latitude;
  double longitude;
  String timezome;
  double pressure;
  int isDay;

  Map<DateTime, HourlyWeatherData> hourlyWeatherData;
  Map<DateTime, DailyWeatherData> dailyWeatherData;

  Forecast(this.latitude, this.longitude, this.timezome, this.pressure,
      this.isDay, this.hourlyWeatherData, this.dailyWeatherData) {
    _initialization();
  }

  Future<void> _initialization() async {
    _preferences = await SharedPreferences.getInstance();
  }

  factory Forecast.fromJson(Map<String, dynamic> json) {
    DateFormat hourFormat = DateFormat('yyyy-MM-ddTHH:mm');
    DateFormat dayFormat = DateFormat("yyyy-MM-dd");

    List<DateTime> times = List<String>.from(json['hourly']['time'])
        .map((time) => hourFormat.parse(time))
        .toList();

    List<DateTime> days = List<String>.from(json['daily']['time'])
        .map((day) => dayFormat.parse(day))
        .toList();

    var dataMap = _extractDataMap(json['hourly']);
    var daysMap = _extractDataMap(json['daily']);

    Map<DateTime, HourlyWeatherData> hourlyWeatherData = {};
    Map<DateTime, DailyWeatherData> dailyWeatherData = {};

    for (int i = 0; i < times.length; i++) {
      hourlyWeatherData[times[i]] = HourlyWeatherData(
        dataMap['temperature_2m']![i],
        dataMap['apparent_temperature']![i],
        dataMap['relative_humidity_2m']![i],
        dataMap['precipitation_probability']![i],
        dataMap['precipitation']![i],
        WeatherCode.fromCode(dataMap['weather_code']![i]),
        dataMap['cloud_cover']![i],
        dataMap['wind_speed_10m']![i],
        dataMap['wind_direction_10m']![i],
        dataMap['wind_gusts_10m']![i],
      );
    }

    for (int i = 0; i < days.length; i++) {
      dailyWeatherData[days[i]] = DailyWeatherData(
        hourFormat.parse(daysMap['sunrise']![i]),
        hourFormat.parse(daysMap['sunset']![i]),
        daysMap['uv_index_max']![i],
        daysMap['uv_index_clear_sky_max']![i],
      );
    }

    return Forecast(
      json['latitude'],
      json['longitude'],
      json['timezone_abbreviation'],
      json['current']['surface_pressure'],
      json['current']['is_day'],
      hourlyWeatherData,
      dailyWeatherData,
    );
  }

  static Map<String, List<dynamic>> _extractDataMap(Map<String, dynamic> data) {
    return data.map((key, value) =>
        MapEntry(key, key == 'time' ? [] : List<dynamic>.from(value)));
  }

  HourlyWeatherData getCurrentHourData([DateTime? date]) {
    DateTime now = DateTime.now();
    return hourlyWeatherData[
        date ?? DateTime(now.year, now.month, now.day, now.hour)]!;
  }

  DailyWeatherData getCurrentDayData([DateTime? date]) {
    DateTime now = DateTime.now();
    return dailyWeatherData[date == null
        ? DateTime(now.year, now.month, now.day)
        : DateTime(date.year, date.month, date.day)]!;
  }

  dynamic getField(SelectableForecastFields field, [DateTime? date]) {
    DateFormat hourFormat = DateFormat("HH:mm");

    HourlyWeatherData currentHourData = getCurrentHourData(date);
    DailyWeatherData currentDayData = getCurrentDayData(date);

    int windSpeedUnit = _preferences.getInt("wind_speed_unit") ?? 0;
    int precipitationUnit = _preferences.getInt("precipitation_unit") ?? 0;

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
      case SelectableForecastFields.isDay:
        return "It is ${isDay == 1 ? "day" : "night"}";
      case SelectableForecastFields.localTime:
        return hourFormat.format(curDateTimeByZone(zone: timezome));
      default:
        return "Unknown";
    }
  }

  CustomClipper<Path> getClipperOfHour(DateTime date) {
    HourlyWeatherData hourlyWeatherData = getCurrentHourData(date);
    DailyWeatherData dailyWeatherData = getCurrentDayData(date);

    bool isBeforeSunset = date.isBefore(dailyWeatherData.sunset);
    bool isAfterSunrise = date.isAfter(dailyWeatherData.sunrise);

    bool isInTheDay = isBeforeSunset && isAfterSunrise;

    return hourlyWeatherData.weatherCode.clipper.getClipper(isInTheDay);
  }

  @override
  String toString() {
    return "${getCurrentHourData().temperature}º - [$latitude|$longitude] - ${getCurrentHourData().weatherCode.description}";
  }
}
