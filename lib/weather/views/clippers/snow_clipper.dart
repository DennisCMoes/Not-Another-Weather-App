import 'package:flutter/material.dart';

class SnowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000000, size.height * 0.3750000);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.6250000);
    path_0.moveTo(size.width * 0.5000000, size.height * 0.3750000);
    path_0.lineTo(size.width * 0.6666667, size.height * 0.2083333);
    path_0.moveTo(size.width * 0.5000000, size.height * 0.3750000);
    path_0.lineTo(size.width * 0.3333333, size.height * 0.2083333);
    path_0.moveTo(size.width * 0.5000000, size.height * 0.3750000);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.1250000);
    path_0.moveTo(size.width * 0.5000000, size.height * 0.6250000);
    path_0.lineTo(size.width * 0.6666667, size.height * 0.7916667);
    path_0.moveTo(size.width * 0.5000000, size.height * 0.6250000);
    path_0.lineTo(size.width * 0.3333333, size.height * 0.7916667);
    path_0.moveTo(size.width * 0.5000000, size.height * 0.6250000);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.8750000);
    path_0.moveTo(size.width * 0.1250000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.3750000, size.height * 0.5000000);
    path_0.moveTo(size.width * 0.8750000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.6250000, size.height * 0.5000000);
    path_0.moveTo(size.width * 0.2083333, size.height * 0.3333333);
    path_0.lineTo(size.width * 0.3750000, size.height * 0.5000000);
    path_0.moveTo(size.width * 0.3750000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.2083333, size.height * 0.6666667);
    path_0.moveTo(size.width * 0.3750000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.6250000, size.height * 0.5000000);
    path_0.moveTo(size.width * 0.6250000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.7916667, size.height * 0.3333333);
    path_0.moveTo(size.width * 0.6250000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.7916667, size.height * 0.6666667);

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
