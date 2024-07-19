import 'package:flutter/material.dart';

class CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.6725684, size.height * 0.2808008)
      ..cubicTo(
          size.width * 0.4970449,
          size.height * 0.1089258,
          size.width * 0.1997109,
          size.height * 0.2032383,
          size.width * 0.1557754,
          size.height * 0.4447559)
      ..cubicTo(size.width * 0.06779297, size.height * 0.4575176, 0,
          size.height * 0.5334434, 0, size.height * 0.6249062)
      ..cubicTo(
          0,
          size.height * 0.7252832,
          size.width * 0.08166211,
          size.height * 0.8069453,
          size.width * 0.1820391,
          size.height * 0.8069453)
      ..lineTo(size.width * 0.7334277, size.height * 0.8069453)
      ..cubicTo(
          size.width * 0.8804160,
          size.height * 0.8069453,
          size.width * 0.9999980,
          size.height * 0.6873633,
          size.width * 0.9999980,
          size.height * 0.5403770)
      ..cubicTo(
          size.width,
          size.height * 0.3696172,
          size.width * 0.8403984,
          size.height * 0.2415664,
          size.width * 0.6725684,
          size.height * 0.2808008)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
