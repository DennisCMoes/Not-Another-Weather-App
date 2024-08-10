mixin IUnit {
  String get label;
  String get value;
}

enum TemperatureUnit with IUnit {
  fahrenheit("Fº", "fahrenheit"),
  celsius("Cº", "celsius");

  const TemperatureUnit(this.label, this.value);

  @override
  final String label;

  @override
  final String value;

  @override
  String toString() => label;
}

enum WindspeedUnit with IUnit {
  mph("MPH", "mph"),
  kmph("KM/H", "kmh"),
  ms("M/S", "ms"),
  knots("KNOTS", "kn");

  const WindspeedUnit(this.label, this.value);

  @override
  final String label;

  @override
  final String value;

  @override
  String toString() => label;
}

enum PrecipitationUnit with IUnit {
  millimeter("MILLIMETER", "mm"),
  inch("INCH", "inch");

  const PrecipitationUnit(this.label, this.value);

  @override
  final String label;

  @override
  final String value;

  @override
  String toString() => label;
}
