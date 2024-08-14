class DailyWeatherData {
  final DateTime time;

  final DateTime sunrise;
  final DateTime sunset;
  final double uvIndex;
  final double clearSkyUvIndex;

  DailyWeatherData(
    this.time,
    this.sunrise,
    this.sunset,
    this.uvIndex,
    this.clearSkyUvIndex,
  );
}
