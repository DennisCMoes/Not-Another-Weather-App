import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/hourly_weather.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_thumb.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_track.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_value_indicator.dart';
import 'package:not_another_weather_app/weather/views/forecast_detail.dart';
import 'package:provider/provider.dart';

class GeocodingCard extends StatefulWidget {
  final PageController pageController;
  final Geocoding geocoding;
  final int index;
  final bool isEditing;
  final ValueSetter<bool> onPressEdit;

  const GeocodingCard(
    this.geocoding, {
    super.key,
    required this.pageController,
    required this.index,
    required this.isEditing,
    required this.onPressEdit,
  });

  @override
  State<GeocodingCard> createState() => GeocodingCardState();
}

class GeocodingCardState extends State<GeocodingCard> {
  double _sliderValue = 0;

  double getScale() {
    double pagePosition = 0;

    if (widget.pageController.position.haveDimensions &&
        widget.pageController.page != null) {
      pagePosition = widget.pageController.page!;
    } else {
      pagePosition = widget.index.toDouble();
    }

    double distanceFromCurrent = (pagePosition - widget.index).abs();
    return 1.0 - (distanceFromCurrent * 0.1).clamp(0.0, 0.1);
  }

  double get baseBottomPadding => MediaQuery.of(context).padding.bottom;
  double get sliderBottomPadding => baseBottomPadding + 20;
  Duration get transitionDuration => const Duration(milliseconds: 500);
  Duration get colorDuration => const Duration(milliseconds: 300);

  double get topPadding =>
      widget.isEditing ? MediaQuery.of(context).padding.top + 40 : 0;
  double get sidePadding =>
      widget.isEditing ? NavigationToolbar.kMiddleSpacing : 0;

  double get cardBottomPadding => widget.isEditing ? baseBottomPadding + 80 : 0;
  double get cardInternalBottomPadding =>
      widget.isEditing ? 30 : baseBottomPadding + 70;
  double get deletionConfirmationPadding => baseBottomPadding + 250;

  ColorPair get colorPair =>
      widget.geocoding.forecast.getColorPair(selectedTime);

  DateTime get selectedTime => DatetimeUtils.convertToTimezone(
        DatetimeUtils.startOfHour().add(Duration(hours: _sliderValue.toInt())),
        widget.geocoding.forecast.timezone,
      );

  HourlyWeatherData get currentHourData =>
      widget.geocoding.forecast.getCurrentHourData(selectedTime);

  String _getSliderLabel() {
    return DateFormat.Hm().format(selectedTime);
  }

  void _onChangeSliderValue(double offset) {
    HapticFeedback.lightImpact();

    setState(() {
      _sliderValue = offset;
    });
  }

  void _resetSliderTime() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _sliderValue = 0.0;
      });
    });
  }

  Widget _buildAnimatedAccentColor({
    required Widget Function(Color color) builder,
  }) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: colorPair.secondary, end: colorPair.secondary),
      duration: colorDuration,
      builder: (context, color, child) {
        return builder(color!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorPair colorPair =
        widget.geocoding.forecast.getColorPair(selectedTime);

    return Transform.scale(
      scale: getScale(),
      child: Stack(
        children: [
          // Center view
          AnimatedContainer(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.only(
              top: topPadding,
              left: sidePadding,
              right: sidePadding,
              bottom: cardBottomPadding,
            ),
            padding: EdgeInsets.only(
              bottom: cardInternalBottomPadding,
            ),
            duration: transitionDuration,
            curve: Curves.easeInOutQuint,
            decoration: BoxDecoration(
              color: colorPair.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Stack(
              children: [
                // Center clipper
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipPath(
                          clipper: widget.geocoding.forecast
                              .getClipperOfHour(selectedTime),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            height: MediaQuery.of(context).size.width - 100,
                            child: RepaintBoundary(
                              child: CustomScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                slivers: [
                                  SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => ClipOval(
                                        child: ColoredBox(
                                          color: colorPair.secondary,
                                        ),
                                      ),
                                      childCount: 400, // 20 * 20
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 20,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 6,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          currentHourData.weatherCode.description,
                          style: context.textTheme.displayMedium!
                              .copyWith(color: colorPair.secondary),
                        )
                      ],
                    ),
                  ),
                ),
                // Weather description
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Forecast details
                        SizedBox(
                          height: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: widget.geocoding.selectedForecastItems
                                .map(
                                  (field) => ForecastDetail(
                                    isEditing: widget.isEditing,
                                    field: field,
                                    geocoding: widget.geocoding,
                                    selectedTime: selectedTime,
                                    colorPair: widget.geocoding.forecast
                                        .getColorPair(selectedTime),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        // Temperature
                        Text(
                          "${currentHourData.temperature.round()}º",
                          style: context.textTheme.displayLarge!.copyWith(
                              fontSize: 128, color: colorPair.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Top bar
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: NavigationToolbar.kMiddleSpacing,
              right: NavigationToolbar.kMiddleSpacing,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.geocoding.name,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.displayMedium!.copyWith(
                    color:
                        widget.isEditing ? Colors.black : colorPair.secondary,
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onPressEdit(!widget.isEditing),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    widget.isEditing ? Icons.edit_off : Icons.edit,
                    color:
                        widget.isEditing ? Colors.black : colorPair.secondary,
                  ),
                ),
              ],
            ),
          ),
          // Bottom slider
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: transitionDuration,
              curve: Curves.easeInOutQuint,
              padding: const EdgeInsets.only(
                left: NavigationToolbar.kMiddleSpacing,
                right: NavigationToolbar.kMiddleSpacing,
              ),
              margin: EdgeInsets.only(bottom: sliderBottomPadding),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOutQuint,
                transitionBuilder: (child, animation) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0.0, 2.0),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: slideAnimation,
                    child: child,
                  );
                },
                child: widget.isEditing
                    ? SizedBox(
                        height: 40,
                        width: double.infinity,
                        key: const ValueKey<int>(1),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: colorPair.primary.darkenColor(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Remove",
                            style: context.textTheme.displaySmall!
                                .copyWith(color: colorPair.secondary),
                          ),
                        ),
                      )
                    : SizedBox(
                        key: const ValueKey<int>(2),
                        height: 40,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 40,
                            valueIndicatorShape: ForecastSliderValueIndicator(),
                            thumbShape: ForecastSliderThumb(),
                            thumbColor: colorPair.primary.lightenColor(0.1),
                            overlayColor: Colors.transparent,
                            activeTrackColor:
                                colorPair.primary.darkenColor(0.1),
                            valueIndicatorColor:
                                colorPair.primary.lightenColor(0.1),
                            valueIndicatorTextStyle: TextStyle(
                              color: colorPair.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                            trackShape: ForecastSliderTrack(
                              DateTime.now(),
                              colorPair.primary,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: 24,
                            divisions: 24,
                            value: _sliderValue,
                            label: _getSliderLabel(),
                            onChanged: _onChangeSliderValue,
                            onChangeEnd: (value) => _resetSliderTime(),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
