import 'package:flutter/material.dart';

class FogClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path combinedPath = Path();

    Path path_0 = Path()
      ..moveTo(size.width * 0.6958333, size.height * 0.3666667)
      ..cubicTo(
          size.width * 0.6166667,
          size.height * 0.3666667,
          size.width * 0.5375000,
          size.height * 0.3333333,
          size.width * 0.4833333,
          size.height * 0.2708333)
      ..cubicTo(
          size.width * 0.4166667,
          size.height * 0.1958333,
          size.width * 0.3041667,
          size.height * 0.1791667,
          size.width * 0.2208333,
          size.height * 0.2375000)
      ..lineTo(size.width * 0.1500000, size.height * 0.2833333)
      ..cubicTo(
          size.width * 0.1291667,
          size.height * 0.2958333,
          size.width * 0.1041667,
          size.height * 0.2916667,
          size.width * 0.09166667,
          size.height * 0.2750000)
      ..cubicTo(
          size.width * 0.07916667,
          size.height * 0.2541667,
          size.width * 0.08333333,
          size.height * 0.2291667,
          size.width * 0.1000000,
          size.height * 0.2166667)
      ..lineTo(size.width * 0.1750000, size.height * 0.1666667)
      ..cubicTo(
          size.width * 0.2916667,
          size.height * 0.08750000,
          size.width * 0.4500000,
          size.height * 0.1083333,
          size.width * 0.5458333,
          size.height * 0.2166667)
      ..cubicTo(
          size.width * 0.6166667,
          size.height * 0.2958333,
          size.width * 0.7375000,
          size.height * 0.3083333,
          size.width * 0.8208333,
          size.height * 0.2416667)
      ..lineTo(size.width * 0.8500000, size.height * 0.2208333)
      ..cubicTo(
          size.width * 0.8666667,
          size.height * 0.2083333,
          size.width * 0.8958333,
          size.height * 0.2083333,
          size.width * 0.9083333,
          size.height * 0.2291667)
      ..cubicTo(
          size.width * 0.9208333,
          size.height * 0.2458333,
          size.width * 0.9208333,
          size.height * 0.2750000,
          size.width * 0.9000000,
          size.height * 0.2875000)
      ..lineTo(size.width * 0.8750000, size.height * 0.3041667)
      ..cubicTo(
          size.width * 0.8208333,
          size.height * 0.3458333,
          size.width * 0.7583333,
          size.height * 0.3666667,
          size.width * 0.6958333,
          size.height * 0.3666667)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_0);

    Path path_1 = Path()
      ..moveTo(size.width * 0.6958333, size.height * 0.6166667)
      ..cubicTo(
          size.width * 0.6166667,
          size.height * 0.6166667,
          size.width * 0.5375000,
          size.height * 0.5833333,
          size.width * 0.4833333,
          size.height * 0.5208333)
      ..cubicTo(
          size.width * 0.4166667,
          size.height * 0.4458333,
          size.width * 0.3041667,
          size.height * 0.4291667,
          size.width * 0.2208333,
          size.height * 0.4875000)
      ..lineTo(size.width * 0.1458333, size.height * 0.5375000)
      ..cubicTo(
          size.width * 0.1250000,
          size.height * 0.5500000,
          size.width * 0.1000000,
          size.height * 0.5458333,
          size.width * 0.08750000,
          size.height * 0.5250000)
      ..cubicTo(
          size.width * 0.07500000,
          size.height * 0.5041667,
          size.width * 0.08333333,
          size.height * 0.4791667,
          size.width * 0.1000000,
          size.height * 0.4666667)
      ..lineTo(size.width * 0.1750000, size.height * 0.4166667)
      ..cubicTo(
          size.width * 0.2916667,
          size.height * 0.3375000,
          size.width * 0.4500000,
          size.height * 0.3583333,
          size.width * 0.5458333,
          size.height * 0.4666667)
      ..cubicTo(
          size.width * 0.6166667,
          size.height * 0.5458333,
          size.width * 0.7375000,
          size.height * 0.5583333,
          size.width * 0.8208333,
          size.height * 0.4916667)
      ..lineTo(size.width * 0.8500000, size.height * 0.4708333)
      ..cubicTo(
          size.width * 0.8666667,
          size.height * 0.4583333,
          size.width * 0.8958333,
          size.height * 0.4583333,
          size.width * 0.9083333,
          size.height * 0.4791667)
      ..cubicTo(
          size.width * 0.9208333,
          size.height * 0.4958333,
          size.width * 0.9208333,
          size.height * 0.5250000,
          size.width * 0.9000000,
          size.height * 0.5375000)
      ..lineTo(size.width * 0.8750000, size.height * 0.5541667)
      ..cubicTo(
          size.width * 0.8208333,
          size.height * 0.5958333,
          size.width * 0.7583333,
          size.height * 0.6166667,
          size.width * 0.6958333,
          size.height * 0.6166667)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_1);

    Path path_2 = Path()
      ..moveTo(size.width * 0.6958333, size.height * 0.8666667)
      ..cubicTo(
          size.width * 0.6166667,
          size.height * 0.8666667,
          size.width * 0.5375000,
          size.height * 0.8333333,
          size.width * 0.4833333,
          size.height * 0.7708333)
      ..cubicTo(
          size.width * 0.4166667,
          size.height * 0.6958333,
          size.width * 0.3041667,
          size.height * 0.6791667,
          size.width * 0.2208333,
          size.height * 0.7375000)
      ..lineTo(size.width * 0.1458333, size.height * 0.7875000)
      ..cubicTo(
          size.width * 0.1250000,
          size.height * 0.8000000,
          size.width * 0.1000000,
          size.height * 0.7958333,
          size.width * 0.08750000,
          size.height * 0.7750000)
      ..cubicTo(
          size.width * 0.07500000,
          size.height * 0.7541667,
          size.width * 0.07916667,
          size.height * 0.7291667,
          size.width * 0.1000000,
          size.height * 0.7166667)
      ..lineTo(size.width * 0.1750000, size.height * 0.6666667)
      ..cubicTo(
          size.width * 0.2916667,
          size.height * 0.5875000,
          size.width * 0.4500000,
          size.height * 0.6083333,
          size.width * 0.5458333,
          size.height * 0.7166667)
      ..cubicTo(
          size.width * 0.6166667,
          size.height * 0.7958333,
          size.width * 0.7375000,
          size.height * 0.8083333,
          size.width * 0.8208333,
          size.height * 0.7416667)
      ..lineTo(size.width * 0.8500000, size.height * 0.7208333)
      ..cubicTo(
          size.width * 0.8666667,
          size.height * 0.7083333,
          size.width * 0.8958333,
          size.height * 0.7083333,
          size.width * 0.9083333,
          size.height * 0.7291667)
      ..cubicTo(
          size.width * 0.9208333,
          size.height * 0.7458333,
          size.width * 0.9208333,
          size.height * 0.7750000,
          size.width * 0.9000000,
          size.height * 0.7875000)
      ..lineTo(size.width * 0.8750000, size.height * 0.8041667)
      ..cubicTo(
          size.width * 0.8208333,
          size.height * 0.8458333,
          size.width * 0.7583333,
          size.height * 0.8666667,
          size.width * 0.6958333,
          size.height * 0.8666667)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_2);

    return combinedPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
