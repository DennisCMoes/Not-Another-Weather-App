import 'package:intl/intl.dart';
import 'package:weather/weather/models/weather_code.dart';

class Forecast {
  double latitude;
  double longitude;
  double temperature;
  WeatherCode weatherCode;
  double windSpeed;
  double precipitation;
  int humidity;
  double pressure;
  Map<DateTime, double> hourlyTemperatures;

  Forecast(
      this.latitude,
      this.longitude,
      this.temperature,
      this.weatherCode,
      this.windSpeed,
      this.precipitation,
      this.humidity,
      this.pressure,
      this.hourlyTemperatures);

  factory Forecast.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat('yyyy-MM-ddThh:mm');

    return Forecast(
        json['latitude'],
        json['longitude'],
        json['current']['temperature_2m'],
        WeatherCode.fromCode(json['current']['weather_code']),
        json['current']['wind_speed_10m'],
        json['current']['precipitation'],
        json['current']['relative_humidity_2m'],
        json['current']['surface_pressure'],
        Map.fromIterables(
          List<String>.from(json['hourly']['time'])
              .map((time) => format.parse(time)),
          List<double>.from(json['hourly']['temperature_2m']),
        ));
  }

  @override
  String toString() {
    return "$temperatureº - [$latitude|$longitude] - ${weatherCode.description}";
  }

  static List<Forecast> sampleData() {
    return [
      Forecast(1, 1, 21.2, WeatherCode.clearSky, 12, 24, 64, 1019, {}),
      Forecast(2, 2, 12.2, WeatherCode.slightRain, 12, 24, 64, 1019, {}),
      Forecast(3, 3, 24.2, WeatherCode.clearSky, 12, 24, 64, 1019, {}),
      Forecast(4, 4, 18.2, WeatherCode.overcast, 12, 24, 64, 1019, {}),
    ];
  }
}
