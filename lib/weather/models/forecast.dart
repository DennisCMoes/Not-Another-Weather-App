import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:instant/instant.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';

class HourlyWeatherData {
  final double temperature;
  final int rainProbability;
  final double rainInMM;

  HourlyWeatherData(this.temperature, this.rainProbability, this.rainInMM);
}

enum SelectableForecastFields {
  temperature("Temperature", Icons.thermostat, true),
  windSpeed("Wind speed", Icons.air, false),
  precipitation("Precipitation", Icons.water_drop, false),
  chainceOfRain("Chance of rain", Icons.umbrella, true),
  sunrise("Sunrise", Icons.keyboard_arrow_up, false),
  sunset("Sunset", Icons.keyboard_arrow_down, false),
  humidity("Humidity", Icons.percent, true),
  windDirection("Wind direction", Icons.directions, false),
  windGusts("Wind gusts", Icons.speed, false),
  cloudCover("Cloud cover", Icons.cloud, true),
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
  double temperature;
  WeatherCode weatherCode;
  double windSpeed;
  double precipitation;
  int humidity;
  double pressure;
  double apparentTemperature;
  int cloudCover;
  int windDirection;
  double windGusts;
  int isDay;

  DateTime sunrise;
  DateTime sunset;

  Map<DateTime, HourlyWeatherData> hourlyWeatherData;

  Forecast(
      this.latitude,
      this.longitude,
      this.timezome,
      this.temperature,
      this.weatherCode,
      this.windSpeed,
      this.precipitation,
      this.humidity,
      this.pressure,
      this.apparentTemperature,
      this.cloudCover,
      this.windDirection,
      this.windGusts,
      this.sunrise,
      this.sunset,
      this.isDay,
      this.hourlyWeatherData);

  factory Forecast.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat('yyyy-MM-ddThh:mm');

    var times = List<String>.from(json['hourly']['time'])
        .map((time) => format.parse(time))
        .toList();
    var temperatures = List<double>.from(json['hourly']['temperature_2m']);
    var rainProbabilities =
        List<int>.from(json['hourly']['precipitation_probability']);
    var rainAmounts = List<double>.from(json['hourly']['precipitation']);

    Map<DateTime, HourlyWeatherData> hourlyWeatherData = {};

    for (int i = 0; i < times.length; i++) {
      hourlyWeatherData[times[i]] = HourlyWeatherData(
        temperatures[i],
        rainProbabilities[i],
        rainAmounts[i],
      );
    }

    return Forecast(
      json['latitude'],
      json['longitude'],
      json['timezone_abbreviation'],
      json['current']['temperature_2m'],
      WeatherCode.fromCode(json['current']['weather_code']),
      json['current']['wind_speed_10m'],
      json['current']['precipitation'],
      json['current']['relative_humidity_2m'],
      json['current']['surface_pressure'],
      json['current']['apparent_temperature'],
      json['current']['cloud_cover'],
      json['current']['wind_direction_10m'],
      json['current']['wind_gusts_10m'],
      format.parse(json['daily']['sunrise'][0]),
      format.parse(json['daily']['sunset'][0]),
      json['current']['is_day'],
      hourlyWeatherData,
    );
  }

  HourlyWeatherData getCurrentHourData() {
    DateTime now = DateTime.now();
    DateTime startOfCurrentHour =
        DateTime(now.year, now.month, now.day, now.hour);
    return hourlyWeatherData[startOfCurrentHour]!;
  }

  Map<DateTime, double> get temperatures => hourlyWeatherData
      .map((dateTime, weather) => MapEntry(dateTime, weather.temperature));

  Map<DateTime, int> get rainProbabilities => hourlyWeatherData
      .map((dateTime, weather) => MapEntry(dateTime, weather.rainProbability));

  Map<DateTime, double> get rainInMMs => hourlyWeatherData
      .map((dateTime, weather) => MapEntry(dateTime, weather.rainInMM));

  dynamic getField(SelectableForecastFields field) {
    DateFormat hourFormat = DateFormat("HH:mm");

    switch (field) {
      case SelectableForecastFields.temperature:
        return "${temperature.round()}º";
      case SelectableForecastFields.windSpeed:
        return "${windSpeed.round()}km/h";
      case SelectableForecastFields.precipitation:
        return "${precipitation}mm";
      case SelectableForecastFields.chainceOfRain:
        return "${rainProbabilities.values.first}%";
      case SelectableForecastFields.sunrise:
        return hourFormat.format(sunrise);
      case SelectableForecastFields.sunset:
        return hourFormat.format(sunset);
      case SelectableForecastFields.humidity:
        return "$humidity%";
      case SelectableForecastFields.windDirection:
        return "$windDirectionº";
      case SelectableForecastFields.windGusts:
        return "${windGusts.round()}km/h";
      case SelectableForecastFields.cloudCover:
        return "$cloudCover%";
      case SelectableForecastFields.isDay:
        return "It is ${isDay == 1 ? "day" : "night"}";
      case SelectableForecastFields.localTime:
        return hourFormat.format(curDateTimeByZone(zone: timezome));
      default:
        return "Unknown";
    }
  }

  @override
  String toString() {
    return "$temperatureº - [$latitude|$longitude] - ${weatherCode.description}";
  }
}
