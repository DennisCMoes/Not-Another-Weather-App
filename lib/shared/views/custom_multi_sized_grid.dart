import 'package:flutter/material.dart';

class GridItem {
  final int id;
  final int rowSpan;
  final int colSpan;
  final Widget child;

  final String? label;
  final IconData? icon;

  GridItem({
    required this.id,
    required this.rowSpan,
    required this.colSpan,
    required this.child,
    this.label,
    this.icon,
  });
}

class CustomMultiSizedGridDelegate extends MultiChildLayoutDelegate {
  final List<GridItem> items;
  final int columnCount;
  final double padding;

  CustomMultiSizedGridDelegate(this.items,
      {this.columnCount = 4, this.padding = 12});

  @override
  void performLayout(Size size) {
    final tileSize = (size.width - (columnCount + 1) * padding) / columnCount;
    List<List<bool>> occupied = List.generate(
      (size.height / tileSize).ceil(),
      (_) => List.filled(columnCount, false),
    );

    for (var item in items) {
      if (hasChild(item.id)) {
        bool placed = false;
        for (int row = 0; row < occupied.length && !placed; row++) {
          for (int col = 0; col <= columnCount - item.colSpan; col++) {
            if (_canPlace(occupied, row, col, item.rowSpan, item.colSpan)) {
              layoutChild(
                item.id,
                BoxConstraints.tight(
                  Size(
                    tileSize * item.colSpan + padding * (item.colSpan - 1),
                    tileSize * item.rowSpan + padding * (item.rowSpan - 1),
                  ),
                ),
              );

              // Calculate position with padding
              final x = col * tileSize + (col + 1) * padding;
              final y = row * tileSize + (row + 1) * padding;

              positionChild(item.id, Offset(x, y));
              _markOccupied(occupied, row, col, item.rowSpan, item.colSpan);
              placed = true;
              break;
            }
          }
        }

        // layoutChild(
        //   item.id,
        //   BoxConstraints.tight(
        //     Size(tileSize * item.colSpan, tileSize * item.rowSpan),
        //   ),
        // );

        // // Calculate the position
        // final x = (item.id % columnCount) * tileSize;
        // final y = (item.id ~/ columnCount) * tileSize;

        // positionChild(item.id, Offset(x, y));
      }
    }
  }

  bool _canPlace(
      List<List<bool>> occupied, int row, int col, int rowSpan, int colSpan) {
    for (int r = row; r < row + rowSpan; r++) {
      for (int c = col; c < col + colSpan; c++) {
        if (r >= occupied.length || c >= occupied[r].length || occupied[r][c]) {
          return false;
        }
      }
    }
    return true;
  }

  void _markOccupied(
      List<List<bool>> occupied, int row, int col, int rowSpan, int colSpan) {
    for (int r = row; r < row + rowSpan; r++) {
      for (int c = col; c < col + colSpan; c++) {
        occupied[r][c] = true;
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}
