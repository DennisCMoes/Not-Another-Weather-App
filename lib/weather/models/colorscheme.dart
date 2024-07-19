import 'dart:ui';

enum WeatherColorScheme {
  silver(Color(0xFFCBC7C6), Color(0xFF000000)),
  gray(Color(0xFF878787), Color(0xFF000000)),
  cuttyShart(Color(0xFF587176), Color(0xFFFFFFFF)),
  dandelion(Color(0xFFFFD85F), Color(0xFF000000));

  final Color mainColor;
  final Color accentColor;

  const WeatherColorScheme(this.mainColor, this.accentColor);
}
