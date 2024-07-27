import 'package:flutter/material.dart';

enum WidgetSize {
  small(2, 1),
  medium(2, 2),
  large(4, 2);

  /// The amount of tiles the widget consumes in horizontal direction
  final int colSpan;

  /// The amount of tiles the widget consumes in vertical direction
  final int rowSpan;

  const WidgetSize(this.colSpan, this.rowSpan);

  @override
  String toString() => name;
}

enum WidgetType {
  compass(),
  sunriseSunset(),
  genericText();

  @override
  String toString() => name;
}

class WidgetItem {
  final int id;

  WidgetSize size;
  WidgetType type;

  WidgetItem({required this.id, required this.size, required this.type});

  Widget getWidget() {
    switch (type) {
      case WidgetType.compass:
        return const Text("Compass");
      case WidgetType.sunriseSunset:
        return const Text("Sunrise and or Sunset");
      default:
        return const Text("Generic");
    }
  }
}
