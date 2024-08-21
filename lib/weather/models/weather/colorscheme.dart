import 'package:flutter/material.dart';

class ColorPair {
  final Color main;
  final Color accent;

  const ColorPair(this.main, this.accent);
}

enum WeatherColorScheme {
  clear(
    ColorPair(Color(0xFF87CEEB), Color(0xFF013366)),
    ColorPair(Color(0xFF013366), Color(0xFFFFFFFF)),
  ),
  partlyCloudy(
    ColorPair(Color(0xFFADD8E6), Color(0xFF003366)),
    ColorPair(Color(0xFF2F4F4F), Color(0xFFFFFFFF)),
  ),
  overcast(
    ColorPair(Color(0xFFDBE7F6), Color(0xFF333333)),
    ColorPair(Color(0xFF4B5D67), Color(0xFFFFFFFF)),
  ),
  drizzle(
    ColorPair(Color(0xFFA9C9D9), Color(0xFF333333)),
    ColorPair(Color(0xFF6A7E90), Color(0xFFFFFFFF)),
  ),
  rain(
    ColorPair(Color(0xFF6D8FAE), Color(0xFFFFFFFF)),
    ColorPair(Color(0xFF2B3A4A), Color(0xFFFFFFFF)),
  ),
  thunderstorm(
    ColorPair(Color(0xFF4F4F4F), Color(0xFFFFD700)),
    ColorPair(Color(0xFF202020), Color(0xFFFFD700)),
  ),
  snow(
    ColorPair(Color(0xFFF0F8FF), Color(0xFF333333)),
    ColorPair(Color(0xFF77989B), Color(0xFF333333)),
  ),
  fog(
    ColorPair(Color(0xFFC0C0C0), Color(0xFF333333)),
    ColorPair(Color(0xFF696969), Color(0xFFFFFFFF)),
  ),
  unknown(
    ColorPair(Color(0xFFF0F8FF), Color(0xFF333333)),
    ColorPair(Color(0xFF77989B), Color(0xFF333333)),
  );

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
