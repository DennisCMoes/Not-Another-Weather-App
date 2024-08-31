import 'package:flutter/material.dart';

class FadeTransitionRoute<T> extends PageRoute<T> {
  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => "IDK";

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  final Widget child;

  FadeTransitionRoute(this.child);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
