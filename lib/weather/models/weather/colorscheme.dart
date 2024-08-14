import 'package:flutter/material.dart';

class ColorPair {
  final Color main;
  final Color accent;

  const ColorPair(this.main, this.accent);
}

enum WeatherColorScheme {
  clear(ColorPair(Color(0xFFFFD700), Color(0xFF000000)),
      ColorPair(Color(0xFF0E1C2E), Color(0xFFFFFFFF))),
  partlyCloudy(ColorPair(Color(0xFF87CEEB), Color(0xFF000000)),
      ColorPair(Color(0xFF2F4F4F), Color(0xFFFFFFFF))),
  overcast(ColorPair(Color(0xFFDBE7F6), Color(0xFF000000)),
      ColorPair(Color(0xFF2C2F32), Color(0xFFFFFFFF))),
  drizzle(ColorPair(Color(0xFFA4C3D8), Color(0xFF000000)),
      ColorPair(Color(0xFFA4C3D8), Color(0xFF000000))),
  rain(ColorPair(Color(0xFF587176), Color(0xFF000000)),
      ColorPair(Color(0xFF587176), Color(0xFF000000))),
  thunderstorm(ColorPair(Color(0xFF3C444D), Color(0xFFFFFFFF)),
      ColorPair(Color(0xFF3C444D), Color(0xFFFFFFFF))),
  snow(ColorPair(Color(0xFFF0F8FF), Color(0xFF000000)),
      ColorPair(Color(0xFFF0F8FF), Color(0xFF000000))),
  fog(ColorPair(Color(0xFFC0C0C0), Color(0xFF000000)),
      ColorPair(Color(0xFFC0C0C0), Color(0xFF000000)));

  // Old colorscheme
  // silver(Color(0xFFCBC7C6), Color(0xFFCBC7C6), Color(0xFF000000)),
  // gray(Color(0xFF878787), Color(0xFF878787), Color(0xFF000000)),
  // cuttyShart(Color(0xFF587176), Color(0xFF587176), Color(0xFFFFFFFF)),
  // dandelion(Color(0xFFFFD85F), Color(0xFFFFD85F), Color(0xFF000000));

  final ColorPair _dayColorPair;
  final ColorPair _nightColorPair;

  const WeatherColorScheme(this._dayColorPair, this._nightColorPair);

  ColorPair getColorPair(bool isDay) => isDay ? _dayColorPair : _nightColorPair;
}
