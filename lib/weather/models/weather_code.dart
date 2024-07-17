enum WeatherCode {
  clearSky(0, "Clear Sky"),
  mainlyClear(1, "Mainly clear"),
  partlyCloudy(2, "Partly clouded"),
  overcast(3, "Overcast"),
  fog(45, "Fog"),
  rimeFog(46, "Depositing rime fog"),
  lightDrizzle(56, "Light freezing drizzle"),
  heavyDrizzle(57, "Heavy freezing drizzle"),
  slightRain(61, "Slight rain"),
  moderateRain(63, "Moderate rain"),
  heavyRain(65, "Heavy rain"),
  lighFreezingRain(66, "Light freezing rain"),
  heavyFreezingRain(67, "Heavy freezing rain"),
  slightSnowFall(71, "Slight snow fall"),
  moderateSnowFall(72, "Moderate snow fall"),
  heavySnowFall(73, "Heavy snow fall"),
  snowGrains(77, "Snow grains"),
  slightRainShower(80, "Slight rain shower"),
  moderateRainShower(81, "Moderate rain shower"),
  violentRainShower(82, "Violent rain shower"),
  slightSnowShower(85, "Slight snow shower"),
  heavySnowShower(86, "Heavy snow shower"),
  thunderstorm(95, "Thunderstorm"),
  thunderstormWithHail(96, "Thunderstorm"),

  unknown(-1, "Something went wrong");

  final int code;
  final String description;

  const WeatherCode(this.code, this.description);

  static WeatherCode fromCode(int code) {
    for (WeatherCode weather in WeatherCode.values) {
      if (weather.code == code) {
        return weather;
      }
    }

    return WeatherCode.unknown;
  }
}
