import 'package:flutter/material.dart';

class ClearNightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5000000, size.height * 0.1250000);
    path_1.cubicTo(
        size.width * 0.5055000,
        size.height * 0.1250000,
        size.width * 0.5109583,
        size.height * 0.1250000,
        size.width * 0.5163750,
        size.height * 0.1250000);
    path_1.arcToPoint(Offset(size.width * 0.8463750, size.height * 0.6435833),
        radius:
            Radius.elliptical(size.width * 0.3125000, size.height * 0.3125000),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.arcToPoint(Offset(size.width * 0.5000000, size.height * 0.1246667),
        radius:
            Radius.elliptical(size.width * 0.3750000, size.height * 0.3750000),
        rotation: 0,
        largeArc: true,
        clockwise: true);
    path_1.close();

    return path_1;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
  // this != oldClipper;
}
