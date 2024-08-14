import 'package:not_another_weather_app/weather/models/weather/weather_code.dart';

class HourlyWeatherData {
  final DateTime time;

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
      this.time,
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
