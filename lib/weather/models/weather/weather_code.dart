import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/weather/weather_clipper.dart';

enum WeatherCode {
  // Sunny
  clearSky(0, "Clear Sky", WeatherColorScheme.clear, WeatherClipper.clear),

  // Cloudy
  mainlyClear(1, "Mainly clear", WeatherColorScheme.partlyCloudy,
      WeatherClipper.partlyClouded),
  partlyCloudy(2, "Partly clouded", WeatherColorScheme.partlyCloudy,
      WeatherClipper.partlyClouded),
  overcast(3, "Overcast", WeatherColorScheme.overcast, WeatherClipper.overcast),

  // Fog
  fog(45, "Fog", WeatherColorScheme.fog, WeatherClipper.fog),
  rimeFog(
      48, "Depositing rime fog", WeatherColorScheme.fog, WeatherClipper.fog),

  // Drizzle
  lightDrizzle(
      51, "Light drizzle", WeatherColorScheme.drizzle, WeatherClipper.drizzle),
  moderateDrizzle(53, "Moderate drizzle", WeatherColorScheme.drizzle,
      WeatherClipper.drizzle),
  denseDrizzle(
      55, "Dense drizzle", WeatherColorScheme.drizzle, WeatherClipper.drizzle),

  // Freezing drizzle
  lightFreezingDrizzle(56, "Light freezing drizzle", WeatherColorScheme.drizzle,
      WeatherClipper.drizzle),
  heavyFreezingDrizzle(57, "Heavy freezing drizzle", WeatherColorScheme.drizzle,
      WeatherClipper.drizzle),

  // Rain
  slightRain(61, "Slight rain", WeatherColorScheme.rain, WeatherClipper.rain),
  moderateRain(
      63, "Moderate rain", WeatherColorScheme.rain, WeatherClipper.rain),
  heavyRain(65, "Heavy rain", WeatherColorScheme.rain, WeatherClipper.rain),

  // Freezing rain
  lighFreezingRain(
      66, "Light freezing rain", WeatherColorScheme.rain, WeatherClipper.rain),
  heavyFreezingRain(
      67, "Heavy freezing rain", WeatherColorScheme.rain, WeatherClipper.rain),

  // Snow
  slightSnowFall(
      71, "Slight snow fall", WeatherColorScheme.snow, WeatherClipper.snow),
  moderateSnowFall(
      72, "Moderate snow fall", WeatherColorScheme.snow, WeatherClipper.snow),
  heavySnowFall(
      73, "Heavy snow fall", WeatherColorScheme.snow, WeatherClipper.snow),
  snowGrains(77, "Snow grains", WeatherColorScheme.snow, WeatherClipper.snow),

  // Rain showers
  slightRainShower(
      80, "Slight rain shower", WeatherColorScheme.rain, WeatherClipper.rain),
  moderateRainShower(
      81, "Moderate rain shower", WeatherColorScheme.rain, WeatherClipper.rain),
  violentRainShower(
      82, "Violent rain shower", WeatherColorScheme.rain, WeatherClipper.rain),

  // Snow showers
  slightSnowShower(
      85, "Slight snow shower", WeatherColorScheme.snow, WeatherClipper.snow),
  heavySnowShower(
      86, "Heavy snow shower", WeatherColorScheme.snow, WeatherClipper.snow),

  // Thunder
  slightOrModerateThunderstorm(95, "Thunderstorm",
      WeatherColorScheme.thunderstorm, WeatherClipper.thunder),
  slightThunderstormWithHail(96, "Thunderstorm",
      WeatherColorScheme.thunderstorm, WeatherClipper.thunder),
  moderateThunderstormWithHail(99, "Thunderstorm",
      WeatherColorScheme.thunderstorm, WeatherClipper.thunder),

  unknown(
    -1,
    "Something went wrong",
    WeatherColorScheme.unknown,
    WeatherClipper.unknown,
  ),
  noInternet(
    -2,
    "No internet",
    WeatherColorScheme.unknown,
    WeatherClipper.unknown,
  ),
  isLoading(
    -3,
    "Is loading",
    WeatherColorScheme.unknown,
    WeatherClipper.unknown,
  );

  final int code;
  final String description;
  final WeatherColorScheme colorScheme;
  final WeatherClipper clipper;

  const WeatherCode(
      this.code, this.description, this.colorScheme, this.clipper);

  static WeatherCode fromCode(int code) {
    for (WeatherCode weather in WeatherCode.values) {
      if (weather.code == code) {
        return weather;
      }
    }

    return WeatherCode.unknown;
  }

  static int toCode(WeatherCode weatherCode) {
    return weatherCode.code;
  }
}
