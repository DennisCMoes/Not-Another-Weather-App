import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/hourly_weather.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_thumb.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_track.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_value_indicator.dart';

class GeocodingCard extends StatefulWidget {
  final PageController pageController;
  final Geocoding geocoding;
  final int index;
  final bool isShowingMenu;
  final ValueSetter<bool> onPressShowMenu;
  final VoidCallback onPressAdd;

  const GeocodingCard(
    this.geocoding, {
    super.key,
    required this.pageController,
    required this.index,
    required this.isShowingMenu,
    required this.onPressShowMenu,
    required this.onPressAdd,
  });

  @override
  State<GeocodingCard> createState() => GeocodingCardState();
}

class GeocodingCardState extends State<GeocodingCard> {
  double _sliderValue = 0;

  double getScale() {
    double pagePosition = 0;

    if (widget.pageController.position.haveDimensions) {
      pagePosition = widget.pageController.page ??
          widget.pageController.initialPage.toDouble();
    }

    double distanceFromCurrent = (pagePosition - widget.index).abs();
    return 1.0 - (distanceFromCurrent * 0.1).clamp(0.0, 0.1);
  }

  double get baseBottomPadding => MediaQuery.of(context).padding.bottom;
  Duration get transitionDuration => const Duration(milliseconds: 500);
  Duration get colorDuration => const Duration(milliseconds: 300);

  double get topPadding =>
      widget.isShowingMenu ? MediaQuery.of(context).padding.top + 40 : 0;
  double get sidePadding =>
      widget.isShowingMenu ? NavigationToolbar.kMiddleSpacing : 0;

  double get cardBottomPadding =>
      widget.isShowingMenu ? baseBottomPadding + 140 : 0;
  double get sliderBottomPadding =>
      widget.isShowingMenu ? baseBottomPadding + 85 : baseBottomPadding + 20;
  double get cardInternalBottomPadding =>
      widget.isShowingMenu ? 10 : baseBottomPadding + 70;

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

  void _showMenu() {
    widget.onPressShowMenu(!widget.isShowingMenu);
  }

  Widget _buildAnimatedAccentColor(
      {required Widget Function(Color color) builder}) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: colorPair.accent, end: colorPair.accent),
      duration: colorDuration,
      builder: (context, color, child) {
        return builder(color!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimatedAccentColor(builder: (accentColor) {
      return Transform.scale(
        scale: getScale(),
        child: Stack(
          children: [
            // Bottom row buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NavigationToolbar.kMiddleSpacing,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _bottomButton(
                          "Edit",
                          () => debugPrint("Left clicked"),
                        ),
                        widget.geocoding.isCurrentLocation
                            ? const SizedBox.shrink()
                            : const SizedBox(width: 12),
                        widget.geocoding.isCurrentLocation
                            ? const SizedBox.shrink()
                            : _bottomButton(
                                "Remove", () => debugPrint("Removing")),
                        const SizedBox(width: 12),
                        _bottomButton("Add", widget.onPressAdd),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Center view
            AnimatedContainer(
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
                color: colorPair.main,
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
                                          child: ColoredBox(color: accentColor),
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
                                .copyWith(color: accentColor),
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
                            height: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: widget.geocoding.selectedForecastItems
                                  .map((field) =>
                                      _weatherDetail(field, accentColor))
                                  .toList(),
                            ),
                          ),
                          // Temperature
                          Text(
                            "${currentHourData.temperature.round()}º",
                            style: context.textTheme.displayLarge!.copyWith(
                              fontSize: 128,
                              color: accentColor,
                            ),
                          )
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
                      color: widget.isShowingMenu ? Colors.black : accentColor,
                    ),
                  ),
                  IconButton(
                    onPressed: _showMenu,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.menu,
                      color: widget.isShowingMenu ? Colors.black : accentColor,
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
                child: SizedBox(
                  height: 40,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 40,
                      valueIndicatorShape: ForecastSliderValueIndicator(),
                      thumbShape: ForecastSliderThumb(),
                      thumbColor: colorPair.main.lightenColor(0.1),
                      overlayColor: Colors.transparent,
                      activeTrackColor: colorPair.main.darkenColor(0.1),
                      valueIndicatorColor: colorPair.main.lightenColor(0.1),
                      valueIndicatorTextStyle: TextStyle(
                        color: colorPair.accent,
                        fontWeight: FontWeight.bold,
                      ),
                      trackShape: ForecastSliderTrack(
                        DateTime.now(),
                        colorPair.main,
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
          ],
        ),
      );
    });
  }

  Widget _bottomButton(String label, VoidCallback? onPress) {
    return Expanded(
      child: Material(
        color: colorPair.main,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPress,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: colorPair.accent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _weatherDetail(SelectableForecastFields field, Color accentColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          field.icon,
          color: accentColor,
        ),
        const SizedBox(width: 6),
        Text(
          widget.geocoding.forecast.getField(field, selectedTime),
          style: TextStyle(
            color: accentColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
