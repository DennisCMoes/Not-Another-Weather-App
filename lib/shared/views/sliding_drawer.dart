import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/providers/drawer_provider.dart';

class SlidingDrawer extends StatefulWidget {
  final Widget drawer;
  final Widget child;
  final int swipeSensitivity;
  final double drawerRatio;
  final Color overlayColor;
  final double overlayOpacity;
  final int animationDuration;
  final Curve animationCurve;

  const SlidingDrawer({
    super.key,
    required this.drawer,
    required this.child,
    this.swipeSensitivity = 15,
    this.drawerRatio = 0.8,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.5,
    this.animationDuration = 500,
    this.animationCurve = Curves.ease,
  });

  @override
  State<SlidingDrawer> createState() => _SlidingDrawerState();
}

class _SlidingDrawerState extends State<SlidingDrawer> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final drawerWidth = width * widget.drawerRatio;

    return Consumer<DrawerProvider>(
      builder: (context, state, child) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > widget.swipeSensitivity) {
              state.openDrawer();
            } else if (details.delta.dx < -widget.swipeSensitivity) {
              state.closeDrawer();
            }
          },
          child: Consumer<DrawerProvider>(
            builder: (context, drawerState, child) {
              return SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      width: drawerWidth,
                      height: height,
                      left: drawerState.isOpened ? 0 : -drawerWidth,
                      curve: widget.animationCurve,
                      duration:
                          Duration(milliseconds: widget.animationDuration),
                      child: Container(
                        color: Colors.white,
                        child: widget.drawer,
                      ),
                    ),
                    AnimatedPositioned(
                      height: height,
                      width: width,
                      left: drawerState.isOpened ? drawerWidth : 0,
                      duration:
                          Duration(milliseconds: widget.animationDuration),
                      curve: widget.animationCurve,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          widget.child,
                          AnimatedSwitcher(
                            duration: Duration(
                                milliseconds: widget.animationDuration),
                            switchInCurve: widget.animationCurve,
                            switchOutCurve: widget.animationCurve,
                            child: drawerState.isOpened
                                ? GestureDetector(
                                    onTap: () {
                                      drawerState.closeDrawer();
                                    },
                                    child: Container(
                                      color: widget.overlayColor
                                          .withOpacity(widget.overlayOpacity),
                                    ),
                                  )
                                : null,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
