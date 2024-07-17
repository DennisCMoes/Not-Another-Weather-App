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

  Forecast(this.latitude, this.longitude, this.temperature, this.weatherCode,
      this.windSpeed, this.precipitation, this.humidity, this.pressure);

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      json['latitude'],
      json['longitude'],
      json['current']['temperature_2m'],
      WeatherCode.fromCode(json['current']['weather_code']),
      json['current']['wind_speed_10m'],
      json['current']['precipitation'],
      json['current']['relative_humidity_2m'],
      json['current']['surface_pressure'],
    );
  }

  @override
  String toString() {
    return "$temperatureº - [$latitude|$longitude] - ${weatherCode.description}";
  }
}
