import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/menu/views/main_menu.dart';
import 'package:not_another_weather_app/shared/extensions/color_extensions.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/shared/utilities/observer_utils.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/weather/colorscheme.dart';
import 'package:not_another_weather_app/weather/models/weather/forecast/daily_weather.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_thumb.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_track.dart';
import 'package:not_another_weather_app/weather/views/components/slider/forecast_slider_value_indicator.dart';
import 'package:not_another_weather_app/weather/views/components/sub_pages/summary_page.dart';
import 'package:provider/provider.dart';

class ForecastCard extends StatefulWidget {
  final Geocoding geocoding;

  const ForecastCard({super.key, required this.geocoding});

  @override
  State<ForecastCard> createState() => ForecastCardState();
}

class ForecastCardState extends State<ForecastCard> with RouteAware {
  late ForecastCardProvider _forecastCardProvider;
  late WeatherProvider _weatherProvider;
  late DateTime _selectedTime;

  bool _isDragging = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();

    _forecastCardProvider = context.read<ForecastCardProvider>();
    _weatherProvider = context.read<WeatherProvider>();

    _selectedTime = _getConvertedTime(time: DateTime.now());
  }

  @override
  void dispose() {
    ObserverUtils.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ObserverUtils.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() async {
    var geo = context.read<WeatherProvider>().getGeocoding(widget.geocoding.id);

    if (geo != null) {
      _forecastCardProvider.setGeocoding(geo);
    }

    super.didPopNext();
  }

  DateTime _getConvertedTime({DateTime? time, int? offset}) {
    time ??= DatetimeUtils.startOfHour();
    offset ??= 0;

    return DatetimeUtils.convertToTimezone(
      time,
      widget.geocoding.forecast.timezone,
    ).add(Duration(hours: offset));
  }

  Future<void> _onChangeSliderValue(double offset) async {
    HapticFeedback.lightImpact();

    if (_forecastCardProvider.isEditing) {
      _forecastCardProvider.setIsEditing(false);
    }

    setState(() {
      _selectedTime = _getConvertedTime(offset: offset.toInt());
      _sliderValue = offset;
    });
  }

  void _resetSliderTime() async {
    setState(() {
      _selectedTime = _getConvertedTime(offset: 0);
      _sliderValue = 0.0;
    });
  }

  String _getSliderLabel(Forecast forecast) {
    final DateTime convertedTime = DatetimeUtils.convertToTimezone(
        _weatherProvider.currentHour, forecast.timezone);
    final DateTime startOfHour = DatetimeUtils.startOfHour(convertedTime)
        .add(Duration(hours: _sliderValue.toInt()));

    final Forecast forecastData = forecast;
    final DailyWeatherData dailyWeatherData =
        forecastData.getCurrentDayData(startOfHour);

    final DateTime sunriseHour =
        DatetimeUtils.startOfHour(dailyWeatherData.sunrise);
    final DateTime sunsetHour =
        DatetimeUtils.startOfHour(dailyWeatherData.sunset);

    if (sunriseHour == startOfHour) {
      return DateFormat.Hm().format(dailyWeatherData.sunrise);
    } else if (sunsetHour == startOfHour) {
      return DateFormat.Hm().format(dailyWeatherData.sunset);
    } else {
      return DateFormat.Hm().format(startOfHour);
    }
  }

  @override
  Widget build(BuildContext context) {
    void toggleIsEditing() {
      HapticFeedback.lightImpact();
      _forecastCardProvider.setIsEditing(!_forecastCardProvider.isEditing);
    }

    void openMainMenu() {
      HapticFeedback.lightImpact();
      Navigator.of(context).push(
        PageRouteBuilder(
          maintainState: true,
          fullscreenDialog: true,
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) {
            return const MainMenuScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.fastOutSlowIn));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }

    return Consumer<ForecastCardProvider>(
      builder: (context, state, child) {
        ColorPair colorPair;

        bool isInvalidCurrent = widget.geocoding.isCurrentLocation &&
            widget.geocoding.latitude == -1 &&
            widget.geocoding.longitude == -1;

        if (isInvalidCurrent) {
          colorPair = WeatherColorScheme.unknown.getColorPair(true);
        } else {
          colorPair = widget.geocoding.forecast
              .getColorPair(_getConvertedTime(offset: _sliderValue.toInt()));
        }

        return ColoredBox(
          color: colorPair.main,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 34),
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.only(
                      left: NavigationToolbar.kMiddleSpacing,
                      right: NavigationToolbar.kMiddleSpacing,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.geocoding.name,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    context.textTheme.displayMedium!.copyWith(
                                  color: colorPair.accent,
                                ),
                              ),
                              Text(
                                state.getSelectedHourDescription(
                                    widget.geocoding.forecast, _selectedTime),
                                style: context.textTheme.displaySmall!.copyWith(
                                  color: colorPair.accent.withOpacity(0.6),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isInvalidCurrent
                                ? const SizedBox.shrink()
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: toggleIsEditing,
                                      icon: Icon(
                                        state.isEditing
                                            ? Icons.edit_off
                                            : Icons.edit,
                                        color: colorPair.accent,
                                      ),
                                    ),
                                  ),
                            IconButton(
                              onPressed: openMainMenu,
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.reorder,
                                color: colorPair.accent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Page view
                  Expanded(
                      child: SummaryPage(
                    geocoding: widget.geocoding,
                    forecastHour: _selectedTime,
                  )),
                  // Bottom Slider
                  isInvalidCurrent
                      ? const SizedBox.shrink()
                      : AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          padding: EdgeInsets.only(
                            top: _isDragging ? 50 : 0,
                            left: NavigationToolbar.kMiddleSpacing,
                            right: NavigationToolbar.kMiddleSpacing,
                            bottom: MediaQuery.of(context).padding.bottom,
                          ),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 40,
                              valueIndicatorShape:
                                  ForecastSliderValueIndicator(),
                              trackShape: ForecastSliderTrack(
                                DatetimeUtils.convertToTimezone(
                                  _weatherProvider.currentHour,
                                  widget.geocoding.forecast.timezone,
                                ),
                                colorPair,
                              ),
                              thumbShape: ForecastSliderThumb(),
                              thumbColor: colorPair.main.lightenColor(0.1),
                              overlayColor: Colors.transparent,
                              activeTrackColor: colorPair.main.darkenColor(0.1),
                              valueIndicatorColor:
                                  colorPair.main.lightenColor(0.1),
                              valueIndicatorTextStyle: TextStyle(
                                color: colorPair.accent,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'tabler-icons',
                              ),
                            ),
                            child: Slider(
                              min: 0,
                              max: 24,
                              divisions: 24,
                              value: _sliderValue,
                              label: _getSliderLabel(widget.geocoding.forecast),
                              onChanged: _onChangeSliderValue,
                              onChangeStart: (value) =>
                                  setState(() => _isDragging = true),
                              onChangeEnd: (value) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () => _resetSliderTime(),
                                );
                                setState(() => _isDragging = false);
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
