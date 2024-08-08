mixin IUnit {
  String get label;
}

enum TemperatureUnit with IUnit {
  fahrenheit("Fº"),
  celsius("Cº");

  const TemperatureUnit(this.label);

  @override
  final String label;

  @override
  String toString() => label;
}

enum WindspeedUnit with IUnit {
  mph("MPH"),
  kmph("KM/H"),
  ms("M/S"),
  knots("KNOTS");

  const WindspeedUnit(this.label);

  @override
  final String label;

  @override
  String toString() => label;
}

enum PrecipitationUnit with IUnit {
  millimeter("MILLIMETER"),
  inch("INCH");

  const PrecipitationUnit(this.label);

  @override
  final String label;

  @override
  String toString() => label;
}
