import 'package:flutter/material.dart';

class PartlyCloudedNight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5416898, size.height * 0.3335342);
    path_0.cubicTo(
        size.width * 0.6737119,
        size.height * 0.3335342,
        size.width * 0.7486058,
        size.height * 0.4209213,
        size.width * 0.7594981,
        size.height * 0.5264561);
    path_0.lineTo(size.width * 0.7628300, size.height * 0.5264560);
    path_0.cubicTo(
        size.width * 0.8477916,
        size.height * 0.5264560,
        size.width * 0.9166667,
        size.height * 0.5951528,
        size.width * 0.9166667,
        size.height * 0.6798947);
    path_0.cubicTo(
        size.width * 0.9166667,
        size.height * 0.7646365,
        size.width * 0.8477916,
        size.height * 0.8333333,
        size.width * 0.7628300,
        size.height * 0.8333333);
    path_0.lineTo(size.width * 0.3205495, size.height * 0.8333333);
    path_0.cubicTo(
        size.width * 0.2355879,
        size.height * 0.8333333,
        size.width * 0.1667128,
        size.height * 0.7646365,
        size.width * 0.1667128,
        size.height * 0.6798947);
    path_0.cubicTo(
        size.width * 0.1667128,
        size.height * 0.5951528,
        size.width * 0.2355879,
        size.height * 0.5264560,
        size.width * 0.3205505,
        size.height * 0.5264560);
    path_0.lineTo(size.width * 0.3238814, size.height * 0.5264561);
    path_0.cubicTo(
        size.width * 0.3348371,
        size.height * 0.4202276,
        size.width * 0.4096676,
        size.height * 0.3335342,
        size.width * 0.5416898,
        size.height * 0.3335342);
    path_0.close();
    path_0.moveTo(size.width * 0.2745863, size.height * 0.1667132);
    path_0.cubicTo(
        size.width * 0.3077124,
        size.height * 0.1684904,
        size.width * 0.3398778,
        size.height * 0.1780369,
        size.width * 0.3688816,
        size.height * 0.1947823);
    path_0.cubicTo(
        size.width * 0.4128436,
        size.height * 0.2201638,
        size.width * 0.4442492,
        size.height * 0.2589417,
        size.width * 0.4609192,
        size.height * 0.3029825);
    path_0.cubicTo(
        size.width * 0.3772492,
        size.height * 0.3268120,
        size.width * 0.3176432,
        size.height * 0.3880396,
        size.width * 0.2936929,
        size.height * 0.4706586);
    path_0.lineTo(size.width * 0.2917798, size.height * 0.4775927);
    path_0.lineTo(size.width * 0.2893729, size.height * 0.4875022);
    path_0.lineTo(size.width * 0.2807760, size.height * 0.4891047);
    path_0.cubicTo(
        size.width * 0.2330455,
        size.height * 0.4991229,
        size.width * 0.1916725,
        size.height * 0.5266661,
        size.width * 0.1637663,
        size.height * 0.5647700);
    path_0.lineTo(size.width * 0.1573317, size.height * 0.5611957);
    path_0.lineTo(size.width * 0.1573317, size.height * 0.5611957);
    path_0.cubicTo(
        size.width * 0.1299351,
        size.height * 0.5453765,
        size.width * 0.1066780,
        size.height * 0.5238983,
        size.width * 0.08890966,
        size.height * 0.4980977);
    path_0.cubicTo(
        size.width * 0.07726427,
        size.height * 0.4811843,
        size.width * 0.08479832,
        size.height * 0.4578255,
        size.width * 0.1041328,
        size.height * 0.4509066);
    path_0.cubicTo(
        size.width * 0.1725669,
        size.height * 0.4264131,
        size.width * 0.2094388,
        size.height * 0.3988488,
        size.width * 0.2305266,
        size.height * 0.3585915);
    path_0.cubicTo(
        size.width * 0.2535576,
        size.height * 0.3146296,
        size.width * 0.2578121,
        size.height * 0.2680054,
        size.width * 0.2425216,
        size.height * 0.2053647);
    path_0.cubicTo(
        size.width * 0.2375503,
        size.height * 0.1849897,
        size.width * 0.2536441,
        size.height * 0.1655896,
        size.width * 0.2745863,
        size.height * 0.1667132);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}
