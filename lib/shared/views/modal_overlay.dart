import 'dart:ui';

import 'package:flutter/material.dart';

class ModalOverlay extends ModalRoute<void> {
  final Widget overlayChild;
  final bool isDismissible;
  final Duration durationOfTransition;

  ModalOverlay({
    required this.overlayChild,
    this.isDismissible = true,
    this.durationOfTransition = const Duration(milliseconds: 300),
  });

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.6);

  @override
  bool get barrierDismissible => isDismissible;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => durationOfTransition;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: animation.value * 10,
          sigmaY: animation.value * 10,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: overlayChild,
      // child: SafeArea(child: overlayChild),
    );
  }
}
