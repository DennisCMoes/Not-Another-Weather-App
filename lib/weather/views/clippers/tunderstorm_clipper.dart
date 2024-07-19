import 'package:flutter/material.dart';

class ThunderstormClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * 0.2957500, size.height * 0.4970844)
      ..lineTo(size.width * 0.4318175, size.height * 0.1250000)
      ..lineTo(size.width * 0.6590919, size.height * 0.1250000)
      ..lineTo(size.width * 0.5227275, size.height * 0.4383225)
      ..lineTo(size.width * 0.7045469, size.height * 0.4383225)
      ..lineTo(size.width * 0.2954531, size.height * 0.8750000)
      ..lineTo(size.width * 0.4335350, size.height * 0.4969594)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
