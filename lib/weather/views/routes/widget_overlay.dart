import 'package:flutter/material.dart';

class WidgetOverlay extends ModalRoute<void> {
  final Widget overlayChild;

  WidgetOverlay({required this.overlayChild});

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.7);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(child: overlayChild),
    );
  }
}
