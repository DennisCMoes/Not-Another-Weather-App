import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/weather/models/colorscheme.dart';

class ScalingTimeSlider extends StatefulWidget {
  final ValueChanged<int> onChange;
  final ColorPair colorPair;

  const ScalingTimeSlider(
      {required this.onChange, required this.colorPair, super.key});

  @override
  State<ScalingTimeSlider> createState() => _ScalingTimeSliderState();
}

class _ScalingTimeSliderState extends State<ScalingTimeSlider> {
  late PageController _timeController;

  @override
  void initState() {
    super.initState();

    _timeController = PageController(
      viewportFraction: 0.2,
      initialPage: DateTime.now().hour,
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    HapticFeedback.lightImpact();
    widget.onChange(index);
  }

  void _onTapOtherHour(int index) {
    widget.onChange(index);
    _timeController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  String _getHourFormat(int index) {
    DateTime now = DateTime.now();
    DateFormat hourFormat = DateFormat("HH:mm");
    DateTime hour = DateTime(now.year, now.month, now.day, index);

    return hourFormat.format(hour);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 48,
      controller: _timeController,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _timeController,
          builder: (context, child) {
            double value = 1.0;

            if (_timeController.position.haveDimensions) {
              value = (_timeController.page ?? 0.0) - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
            } else {
              value = (index == 0) ? 1.0 : 0.7;
            }

            return Center(
              child: Transform.scale(
                scale: Curves.easeOut.transform(value),
                child: child,
              ),
            );
          },
          child: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(8),
            color: widget.colorPair.main.darkenColor(0.1),
            child: InkWell(
              onTap: () => _onTapOtherHour(index),
              child: Center(
                child: Text(
                  _getHourFormat(index),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: widget.colorPair.accent),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
