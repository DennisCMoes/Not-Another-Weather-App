import 'package:flutter/material.dart';

enum WeatherColorScheme {
  clearAndSunny(Color(0xFFFFD700), Color(0xFF000000)),
  clearNight(Color(0xFF1E1E1E), Color(0xFFFFFFFF)),
  partlyCloudyDay(Color(0xFF87CEEB), Color(0xFF000000)),
  partlyCloudyNight(Color(0xFF2F4F4F), Color(0xFFFFFFFF)),
  cloudy(Color(0xFFB0C4De), Color(0xFF000000)),
  overcast(Color(0xFF708090), Color(0xFF000000)),
  lightRain(Color(0xFFA4C3D8), Color(0xFF000000)),
  rain(Color(0xFF587176), Color(0xFF000000)),
  thunderstorm(Color(0xFF3C444D), Color(0xFFFFFFFF)),
  snow(Color(0xFFF0F8FF), Color(0xFF000000)),
  fog(Color(0xFFC0C0C0), Color(0xFF000000)),

  // Old colorscheme
  silver(Color(0xFFCBC7C6), Color(0xFF000000)),
  gray(Color(0xFF878787), Color(0xFF000000)),
  cuttyShart(Color(0xFF587176), Color(0xFFFFFFFF)),
  dandelion(Color(0xFFFFD85F), Color(0xFF000000));

  final Color mainColor;
  final Color accentColor;

  const WeatherColorScheme(this.mainColor, this.accentColor);

  Color darkenMainColor([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(mainColor);
    final darkenedHsl =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return darkenedHsl.toColor();
  }
}
