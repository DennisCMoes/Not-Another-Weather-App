import 'package:flutter/material.dart';

class FadeSlideRoute extends PageRouteBuilder {
  final Widget page;

  FadeSlideRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeTween = Tween(begin: 0.0, end: 0.7);
            final fadeAnimation = animation.drive(
                fadeTween.chain(CurveTween(curve: Curves.easeInOutQuint)));

            final slideTween =
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
            final slideAnimation = animation.drive(
                slideTween.chain(CurveTween(curve: Curves.easeInOutQuint)));

            return Stack(
              children: [
                FadeTransition(
                  opacity: fadeAnimation,
                  child: Container(
                    color: Colors.black.withOpacity(fadeAnimation.value),
                  ),
                ),
                SlideTransition(
                  position: slideAnimation,
                  child: child,
                ),
              ],
            );
          },
        );
}
