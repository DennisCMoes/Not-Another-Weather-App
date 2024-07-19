import 'package:flutter/material.dart';

class RainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.4999962, size.height)
      ..cubicTo(
          size.width * 0.6936734,
          size.height,
          size.width * 0.8512572,
          size.height * 0.8424540,
          size.width * 0.8512572,
          size.height * 0.6487882)
      ..cubicTo(
          size.width * 0.8512572,
          size.height * 0.4591176,
          size.width * 0.5220589,
          size.height * 0.02863957,
          size.width * 0.5080396,
          size.height * 0.01041336)
      ..lineTo(size.width * 0.4999962, 0)
      ..lineTo(size.width * 0.4919528, size.height * 0.01048140)
      ..cubicTo(
          size.width * 0.4779524,
          size.height * 0.02867359,
          size.width * 0.1487391,
          size.height * 0.4591819,
          size.width * 0.1487391,
          size.height * 0.6488222)
      ..cubicTo(
          size.width * 0.1487428,
          size.height * 0.8424540,
          size.width * 0.3063229,
          size.height,
          size.width * 0.4999962,
          size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
