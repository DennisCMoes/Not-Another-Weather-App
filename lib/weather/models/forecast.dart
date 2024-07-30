import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:instant/instant.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';

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

enum SelectableForecastFields {
  temperature("Temperature", Icons.thermostat, true),
  windSpeed("Wind speed", Icons.air, false),
  precipitation("Precipitation", Icons.water_drop, false),
  chainceOfRain("Chance of rain", Icons.umbrella, false),
  sunrise("Sunrise", Icons.keyboard_arrow_up, false),
  sunset("Sunset", Icons.keyboard_arrow_down, false),
  humidity("Humidity", Icons.percent, true),
  windDirection("Wind direction", Icons.directions, false),
  windGusts("Wind gusts", Icons.speed, false),
  cloudCover("Cloud cover", Icons.cloud, false),
  isDay("Day or night", Icons.access_time, false),
  localTime("Local time", Icons.circle, false);

  const SelectableForecastFields(
      this.label, this.icon, this.mainFieldAccessible);

  final String label;
  final IconData icon;
  final bool mainFieldAccessible;
}

class Forecast {
  double latitude;
  double longitude;
  String timezome;
  double pressure;
  int isDay;

  DateTime sunrise;
  DateTime sunset;

  Map<DateTime, HourlyWeatherData> hourlyWeatherData;

  Forecast(this.latitude, this.longitude, this.timezome, this.pressure,
      this.sunrise, this.sunset, this.isDay, this.hourlyWeatherData);

  factory Forecast.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat('yyyy-MM-ddTHH:mm');
    List<DateTime> times = List<String>.from(json['hourly']['time'])
        .map((time) => format.parse(time))
        .toList();

    Map<String, List<dynamic>> dataMap = {};

    (json['hourly'] as Map<String, dynamic>).forEach((key, value) {
      if (key != 'time') {
        dataMap[key] = List<dynamic>.from(value);
      }
    });

    Map<DateTime, HourlyWeatherData> hourlyWeatherData = {};

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

    return Forecast(
      json['latitude'],
      json['longitude'],
      json['timezone_abbreviation'],
      json['current']['surface_pressure'],
      format.parse(json['daily']['sunrise'][0]),
      format.parse(json['daily']['sunset'][0]),
      json['current']['is_day'],
      hourlyWeatherData,
    );
  }

  HourlyWeatherData getCurrentHourData([int? hour]) {
    DateTime now = DateTime.now();
    DateTime startOfCurrentHour =
        DateTime(now.year, now.month, now.day, hour ?? now.hour);
    return hourlyWeatherData[startOfCurrentHour]!;
  }

  dynamic getField(SelectableForecastFields field, [int? hour]) {
    DateFormat hourFormat = DateFormat("HH:mm");
    HourlyWeatherData currentHourData = getCurrentHourData(hour);

    switch (field) {
      case SelectableForecastFields.temperature:
        return "${currentHourData.temperature.round()}º";
      case SelectableForecastFields.windSpeed:
        return "${currentHourData.windSpeed.round()}km/h";
      case SelectableForecastFields.precipitation:
        return "${currentHourData.rainInMM}mm";
      case SelectableForecastFields.chainceOfRain:
        return "${currentHourData.rainProbability}%";
      case SelectableForecastFields.sunrise:
        return hourFormat.format(sunrise);
      case SelectableForecastFields.sunset:
        return hourFormat.format(sunset);
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

  CustomClipper<Path> getClipperOfHour([int? hour]) {
    DateTime now = DateTime.now();
    DateTime startOfCurrentHour =
        DateTime(now.year, now.month, now.day, hour ?? now.hour);
    HourlyWeatherData hourlyData = hourlyWeatherData[startOfCurrentHour]!;

    bool isInTheDay = startOfCurrentHour.isBefore(sunset) &&
        startOfCurrentHour.isAfter(sunrise);

    return hourlyData.weatherCode.clipper.getClipper(isInTheDay);
  }

  @override
  String toString() {
    return "${getCurrentHourData().temperature}º - [$latitude|$longitude] - ${getCurrentHourData().weatherCode.description}";
  }
}
