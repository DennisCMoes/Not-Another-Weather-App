class Forecast {
  double latitude;
  double longitude;
  double temperature;
  int weatherCode;
  double windSpeed;
  double precipitation;
  int humidity;

  Forecast(this.latitude, this.longitude, this.temperature, this.weatherCode,
      this.windSpeed, this.precipitation, this.humidity);

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      json['latitude'],
      json['longitude'],
      json['current']['temperature_2m'],
      json['current']['weather_code'],
      json['current']['wind_speed_10m'],
      json['current']['precipitation'],
      json['current']['relative_humidity_2m'],
    );
  }

  @override
  String toString() {
    return "$temperatureº - [$latitude|$longitude]";
  }
}
