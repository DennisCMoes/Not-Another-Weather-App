import 'package:flutter/material.dart';

extension ColorManipulation on Color {
  /// Darkens the color by the specified [amount]
  ///
  /// The [amount] must be between 0 and 1, inclusive, where 0 is no change and 1 is completely dark
  ///
  /// Defaults to 0.1 if not specified
  ///
  /// Returns a new [Color] that is darker by the specified [amount]
  ///
  /// Throws an [AssertionError] if [amount] is not between 0 and 1
  Color darkenColor([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final darkenedHsl =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return darkenedHsl.toColor();
  }

  /// Lightens the color by the specified [amount]
  ///
  /// The [amount] must be between 0 and 1, inclusive, where 0 is no change and 1 is completely light
  ///
  /// Defaults to 0.1 if not specified
  ///
  /// Returns a new [Color] that is lighter by the specified [amount]
  ///
  /// Throws an [AssertionError] if [amount] is not between 0 and 1
  Color lightenColor([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightenedHsl =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return lightenedHsl.toColor();
  }
}
