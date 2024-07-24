import 'package:intl/intl.dart';
import 'package:not_another_weather_app/weather/models/weather_code.dart';

class HourlyWeatherData {
  final double temperature;
  final int rainProbability;
  final double rainInMM;

  HourlyWeatherData(this.temperature, this.rainProbability, this.rainInMM);
}

class Forecast {
  double latitude;
  double longitude;
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

  @override
  String toString() {
    return "$temperatureº - [$latitude|$longitude] - ${weatherCode.description}";
  }
}
