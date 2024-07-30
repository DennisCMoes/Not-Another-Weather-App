import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClearDayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path combinedPath = Path();

    Path path_0 = Path()
      ..moveTo(size.width * 0.4895833, size.height * 0.2291667)
      ..cubicTo(
          size.width * 0.4665708,
          size.height * 0.2291667,
          size.width * 0.4479167,
          size.height * 0.2105117,
          size.width * 0.4479167,
          size.height * 0.1875000)
      ..lineTo(size.width * 0.4479167, size.height * 0.08333333)
      ..cubicTo(
          size.width * 0.4479167,
          size.height * 0.06032167,
          size.width * 0.4665708,
          size.height * 0.04166667,
          size.width * 0.4895833,
          size.height * 0.04166667)
      ..lineTo(size.width * 0.5104167, size.height * 0.04166667)
      ..cubicTo(
          size.width * 0.5334292,
          size.height * 0.04166667,
          size.width * 0.5520833,
          size.height * 0.06032167,
          size.width * 0.5520833,
          size.height * 0.08333333)
      ..lineTo(size.width * 0.5520833, size.height * 0.1875000)
      ..cubicTo(
          size.width * 0.5520833,
          size.height * 0.2105117,
          size.width * 0.5334292,
          size.height * 0.2291667,
          size.width * 0.5104167,
          size.height * 0.2291667)
      ..lineTo(size.width * 0.4895833, size.height * 0.2291667)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_0);

    Path path_1 = Path()
      ..moveTo(size.width * 0.6841417, size.height * 0.3011242)
      ..cubicTo(
          size.width * 0.6678708,
          size.height * 0.2848525,
          size.width * 0.6678708,
          size.height * 0.2584704,
          size.width * 0.6841417,
          size.height * 0.2421988)
      ..lineTo(size.width * 0.7578000, size.height * 0.1685417)
      ..cubicTo(
          size.width * 0.7740708,
          size.height * 0.1522696,
          size.width * 0.8004542,
          size.height * 0.1522696,
          size.width * 0.8167250,
          size.height * 0.1685417)
      ..lineTo(size.width * 0.8314542, size.height * 0.1832729)
      ..cubicTo(
          size.width * 0.8477292,
          size.height * 0.1995450,
          size.width * 0.8477292,
          size.height * 0.2259267,
          size.width * 0.8314542,
          size.height * 0.2421988)
      ..lineTo(size.width * 0.7578000, size.height * 0.3158554)
      ..cubicTo(
          size.width * 0.7415292,
          size.height * 0.3321275,
          size.width * 0.7151458,
          size.height * 0.3321275,
          size.width * 0.6988750,
          size.height * 0.3158554)
      ..lineTo(size.width * 0.6841417, size.height * 0.3011242)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_1);

    Path path_2 = Path()
      ..moveTo(size.width * 0.7708333, size.height * 0.4895833)
      ..cubicTo(
          size.width * 0.7708333,
          size.height * 0.4665708,
          size.width * 0.7894875,
          size.height * 0.4479167,
          size.width * 0.8125000,
          size.height * 0.4479167)
      ..lineTo(size.width * 0.9166667, size.height * 0.4479167)
      ..cubicTo(
          size.width * 0.9396792,
          size.height * 0.4479167,
          size.width * 0.9583333,
          size.height * 0.4665708,
          size.width * 0.9583333,
          size.height * 0.4895833)
      ..lineTo(size.width * 0.9583333, size.height * 0.5104167)
      ..cubicTo(
          size.width * 0.9583333,
          size.height * 0.5334292,
          size.width * 0.9396792,
          size.height * 0.5520833,
          size.width * 0.9166667,
          size.height * 0.5520833)
      ..lineTo(size.width * 0.8125000, size.height * 0.5520833)
      ..cubicTo(
          size.width * 0.7894875,
          size.height * 0.5520833,
          size.width * 0.7708333,
          size.height * 0.5334292,
          size.width * 0.7708333,
          size.height * 0.5104167)
      ..lineTo(size.width * 0.7708333, size.height * 0.4895833)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_2);

    Path path_3 = Path()
      ..moveTo(size.width * 0.6988667, size.height * 0.6841417)
      ..cubicTo(
          size.width * 0.7151375,
          size.height * 0.6678708,
          size.width * 0.7415208,
          size.height * 0.6678708,
          size.width * 0.7577917,
          size.height * 0.6841417)
      ..lineTo(size.width * 0.8314500, size.height * 0.7578000)
      ..cubicTo(
          size.width * 0.8477208,
          size.height * 0.7740708,
          size.width * 0.8477208,
          size.height * 0.8004542,
          size.width * 0.8314500,
          size.height * 0.8167250)
      ..lineTo(size.width * 0.8167167, size.height * 0.8314542)
      ..cubicTo(
          size.width * 0.8004458,
          size.height * 0.8477292,
          size.width * 0.7740625,
          size.height * 0.8477292,
          size.width * 0.7577917,
          size.height * 0.8314542)
      ..lineTo(size.width * 0.6841333, size.height * 0.7578000)
      ..cubicTo(
          size.width * 0.6678625,
          size.height * 0.7415292,
          size.width * 0.6678625,
          size.height * 0.7151458,
          size.width * 0.6841333,
          size.height * 0.6988750)
      ..lineTo(size.width * 0.6988667, size.height * 0.6841417)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_3);

    Path path_4 = Path()
      ..moveTo(size.width * 0.5104167, size.height * 0.7708333)
      ..cubicTo(
          size.width * 0.5334292,
          size.height * 0.7708333,
          size.width * 0.5520833,
          size.height * 0.7894875,
          size.width * 0.5520833,
          size.height * 0.8125000)
      ..lineTo(size.width * 0.5520833, size.height * 0.9166667)
      ..cubicTo(
          size.width * 0.5520833,
          size.height * 0.9396792,
          size.width * 0.5334292,
          size.height * 0.9583333,
          size.width * 0.5104167,
          size.height * 0.9583333)
      ..lineTo(size.width * 0.4895833, size.height * 0.9583333)
      ..cubicTo(
          size.width * 0.4665708,
          size.height * 0.9583333,
          size.width * 0.4479167,
          size.height * 0.9396792,
          size.width * 0.4479167,
          size.height * 0.9166667)
      ..lineTo(size.width * 0.4479167, size.height * 0.8125000)
      ..cubicTo(
          size.width * 0.4479167,
          size.height * 0.7894875,
          size.width * 0.4665708,
          size.height * 0.7708333,
          size.width * 0.4895833,
          size.height * 0.7708333)
      ..lineTo(size.width * 0.5104167, size.height * 0.7708333)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_4);

    Path path_5 = Path()
      ..moveTo(size.width * 0.3158579, size.height * 0.6988750)
      ..cubicTo(
          size.width * 0.3321296,
          size.height * 0.7151458,
          size.width * 0.3321296,
          size.height * 0.7415292,
          size.width * 0.3158579,
          size.height * 0.7578000)
      ..lineTo(size.width * 0.2422008, size.height * 0.8314583)
      ..cubicTo(
          size.width * 0.2259292,
          size.height * 0.8477292,
          size.width * 0.1995471,
          size.height * 0.8477292,
          size.width * 0.1832754,
          size.height * 0.8314583)
      ..lineTo(size.width * 0.1685437, size.height * 0.8167250)
      ..cubicTo(
          size.width * 0.1522721,
          size.height * 0.8004542,
          size.width * 0.1522721,
          size.height * 0.7740750,
          size.width * 0.1685437,
          size.height * 0.7578000)
      ..lineTo(size.width * 0.2422008, size.height * 0.6841458)
      ..cubicTo(
          size.width * 0.2584725,
          size.height * 0.6678708,
          size.width * 0.2848546,
          size.height * 0.6678708,
          size.width * 0.3011262,
          size.height * 0.6841458)
      ..lineTo(size.width * 0.3158579, size.height * 0.6988750)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_5);

    Path path_6 = Path()
      ..moveTo(size.width * 0.2291667, size.height * 0.5104167)
      ..cubicTo(
          size.width * 0.2291667,
          size.height * 0.5334292,
          size.width * 0.2105117,
          size.height * 0.5520833,
          size.width * 0.1875000,
          size.height * 0.5520833)
      ..lineTo(size.width * 0.08333333, size.height * 0.5520833)
      ..cubicTo(
          size.width * 0.06032167,
          size.height * 0.5520833,
          size.width * 0.04166667,
          size.height * 0.5334292,
          size.width * 0.04166667,
          size.height * 0.5104167)
      ..lineTo(size.width * 0.04166667, size.height * 0.4895833)
      ..cubicTo(
          size.width * 0.04166667,
          size.height * 0.4665708,
          size.width * 0.06032167,
          size.height * 0.4479167,
          size.width * 0.08333333,
          size.height * 0.4479167)
      ..lineTo(size.width * 0.1875000, size.height * 0.4479167)
      ..cubicTo(
          size.width * 0.2105117,
          size.height * 0.4479167,
          size.width * 0.2291667,
          size.height * 0.4665708,
          size.width * 0.2291667,
          size.height * 0.4895833)
      ..lineTo(size.width * 0.2291667, size.height * 0.5104167)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_6);

    Path path_7 = Path()
      ..moveTo(size.width * 0.3011342, size.height * 0.3158579)
      ..cubicTo(
          size.width * 0.2848625,
          size.height * 0.3321296,
          size.width * 0.2584804,
          size.height * 0.3321296,
          size.width * 0.2422088,
          size.height * 0.3158579)
      ..lineTo(size.width * 0.1685517, size.height * 0.2422008)
      ..cubicTo(
          size.width * 0.1522800,
          size.height * 0.2259292,
          size.width * 0.1522800,
          size.height * 0.1995471,
          size.width * 0.1685517,
          size.height * 0.1832754)
      ..lineTo(size.width * 0.1832833, size.height * 0.1685437)
      ..cubicTo(
          size.width * 0.1995550,
          size.height * 0.1522721,
          size.width * 0.2259367,
          size.height * 0.1522721,
          size.width * 0.2422088,
          size.height * 0.1685437)
      ..lineTo(size.width * 0.3158658, size.height * 0.2422008)
      ..cubicTo(
          size.width * 0.3321375,
          size.height * 0.2584725,
          size.width * 0.3321375,
          size.height * 0.2848546,
          size.width * 0.3158658,
          size.height * 0.3011262)
      ..lineTo(size.width * 0.3011342, size.height * 0.3158579)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_7);

    Path path_8 = Path()
      ..moveTo(size.width * 0.2916667, size.height * 0.5000000)
      ..cubicTo(
          size.width * 0.2916667,
          size.height * 0.3849408,
          size.width * 0.3849408,
          size.height * 0.2916667,
          size.width * 0.5000000,
          size.height * 0.2916667)
      ..cubicTo(
          size.width * 0.6150583,
          size.height * 0.2916667,
          size.width * 0.7083333,
          size.height * 0.3849408,
          size.width * 0.7083333,
          size.height * 0.5000000)
      ..cubicTo(
          size.width * 0.7083333,
          size.height * 0.6150583,
          size.width * 0.6150583,
          size.height * 0.7083333,
          size.width * 0.5000000,
          size.height * 0.7083333)
      ..cubicTo(
          size.width * 0.3849408,
          size.height * 0.7083333,
          size.width * 0.2916667,
          size.height * 0.6150583,
          size.width * 0.2916667,
          size.height * 0.5000000)
      ..close();

    combinedPath = Path.combine(PathOperation.union, combinedPath, path_8);

    return combinedPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
