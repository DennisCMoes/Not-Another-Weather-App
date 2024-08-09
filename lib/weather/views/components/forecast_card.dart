import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_another_weather_app/menu/views/main_menu.dart';
import 'package:not_another_weather_app/shared/utilities/observer_utils.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/views/components/scaling_time_slider.dart';
import 'package:not_another_weather_app/weather/views/components/sub_pages/summary_page.dart';
import 'package:provider/provider.dart';

class ForecastCard extends StatefulWidget {
  const ForecastCard({super.key});

  @override
  State<ForecastCard> createState() => ForecastCardState();
}

class ForecastCardState extends State<ForecastCard> with RouteAware {
  late CurrentGeocodingProvider _geocodingProvider;

  final List<String> _subPageButtonLabels = [
    "Summary",
    // "Details",
  ];
  final PageController _timeController = PageController(viewportFraction: 0.2);

  bool _showTimeSlider = false;

  @override
  void initState() {
    super.initState();

    _geocodingProvider =
        Provider.of<CurrentGeocodingProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _timeController.dispose();
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
    var geo = context
        .read<WeatherProvider>()
        .getGeocoding(_geocodingProvider.geocoding.id);

    // TODO: Find a way to only call this function if the data has changed
    _geocodingProvider.setGeocoding(geo);
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    void toggleIsEditing() {
      HapticFeedback.lightImpact();
      _geocodingProvider.setIsEditing(!_geocodingProvider.isEditing);
    }

    void onChangeSelectedHour(DateTime time) {
      _geocodingProvider.setFutureForecastIndex(time);
    }

    void toggleTimeSlider() {
      setState(() {
        _showTimeSlider = !_showTimeSlider;
      });
    }

    void resetSelectedTime() {
      _geocodingProvider.setFutureForecastIndex(DateTime.now());
      var index = _geocodingProvider.get24hForecastIndex(DateTime.now());
      _geocodingProvider.futureForecastController.jumpToPage(index);

      setState(() {
        _showTimeSlider = false;
      });
    }

    bool currentHourIsSelected() {
      DateTime now = DateTime.now();
      DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);

      return currentHour.isAtSameMomentAs(_geocodingProvider.selectedHour) &&
          DateUtils.isSameDay(currentHour, _geocodingProvider.selectedHour);
    }

    void openMainMenu() {
      Navigator.of(context).push(
        PageRouteBuilder(
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

    return Consumer<CurrentGeocodingProvider>(
      builder: (context, state, child) {
        return ColoredBox(
          color: state.getWeatherColorScheme().main,
          child: Padding(
            padding: EdgeInsets.only(
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: NavigationToolbar.kMiddleSpacing,
                    right: NavigationToolbar.kMiddleSpacing,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      state.geocoding.forecast == null
                          ? Text("Loading",
                              style: Theme.of(context).textTheme.displayLarge)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.geocoding.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        color: state
                                            .getWeatherColorScheme()
                                            .accent,
                                      ),
                                ),
                                Text(
                                  state.getSelectedHourDescription(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: state
                                            .getWeatherColorScheme()
                                            .accent
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ],
                            ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          currentHourIsSelected()
                              ? const SizedBox.shrink()
                              : IconButton(
                                  onPressed: resetSelectedTime,
                                  icon: Icon(
                                    Icons.restore,
                                    color: state.getWeatherColorScheme().accent,
                                  ),
                                ),
                          Provider.of<DeviceProvider>(context).hasInternet
                              ? const SizedBox.shrink()
                              : const Icon(
                                  Icons.signal_wifi_connected_no_internet_4),
                          IconButton(
                            // onPressed: () {
                            //   Provider.of<DrawerProvider>(context,
                            //           listen: false)
                            //       .openDrawer();
                            // },
                            onPressed: openMainMenu,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.reorder,
                              color: state.getWeatherColorScheme().accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Page view
                Expanded(
                  child: PageView(
                    controller: state.subPageController,
                    onPageChanged: (index) => state.setSubPageIndex(index),
                    children: const <Widget>[
                      SummaryPage(),
                      // PageTwo(),
                    ],
                  ),
                ),
                AnimatedContainer(
                  height: _showTimeSlider ? 75 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: ClipRRect(
                    child: OverflowBox(
                      maxHeight: 75,
                      child: SizedBox(
                        height: 75,
                        width: MediaQuery.of(context).size.width,
                        child: ChangeNotifierProvider.value(
                          value: state,
                          child: ScalingTimeSlider(
                            onChange: onChangeSelectedHour,
                            colorPair: state.getWeatherColorScheme(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: toggleIsEditing,
                          icon: Icon(
                            state.isEditing ? Icons.edit_off : Icons.edit,
                            color: state.getWeatherColorScheme().accent,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: toggleTimeSlider,
                          icon: Icon(
                            Icons.schedule,
                            color: state.getWeatherColorScheme().accent,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            _subPageButtonLabels.length,
                            (index) => GestureDetector(
                              onTap: () {
                                state.subPageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                transform: state.isCurrentPage(index)
                                    ? Matrix4.identity()
                                    : (Matrix4.identity()..scale(0.9)),
                                child: Text(
                                  _subPageButtonLabels[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: state.isCurrentPage(index)
                                            ? state
                                                .getWeatherColorScheme()
                                                .accent
                                            : state
                                                .getWeatherColorScheme()
                                                .accent
                                                .withOpacity(0.6),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
