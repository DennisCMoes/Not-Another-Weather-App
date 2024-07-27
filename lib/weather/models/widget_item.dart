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

class WidgetItem {
  final int id;
  WidgetSize size;

  WidgetItem({required this.id, required this.size});
}
