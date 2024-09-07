import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/datetime_utils.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_card.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, required this.initialIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, RouteAware {
  late WeatherProvider _weatherProvider;
  late ForecastCardProvider _forecastCardProvider;
  late PageController _pageController;
  late int _selectedPageIndex;

  final LocationController locationController = LocationController();
  final ForecastRepo forecastRepo = ForecastRepo();

  DateTime _hour = DatetimeUtils.startOfHour();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _weatherProvider = context.read<WeatherProvider>();
    _forecastCardProvider = context.read<ForecastCardProvider>();

    _pageController = PageController(initialPage: widget.initialIndex);
    _selectedPageIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _hour = DatetimeUtils.startOfHour();
      _weatherProvider.refreshData();
    }
  }

  String getRefreshString() {
    return DateFormat("HH:mm").format(_weatherProvider.refreshTime);
  }

  void _onForecastPageChange(int page) {
    HapticFeedback.mediumImpact();
    _forecastCardProvider.setGeocoding(_weatherProvider.geocodings[page]);

    print("$page - ${_forecastCardProvider.geocoding}");
    setState(() {
      _selectedPageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    void onStatusBarTap() {
      // double pageIndex = _weatherProvider.pageController.page ?? 0;

      // if (pageIndex > 0) {
      //   _weatherProvider.pageController.animateToPage(0,
      //       duration: const Duration(milliseconds: 600),
      //       curve: Curves.easeInOut);
      // }
    }

    return Stack(
      children: [
        Scaffold(body: _buildHomeScreen()),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: context.padding.top,
          child: GestureDetector(
            excludeFromSemantics: true,
            onTap: onStatusBarTap,
          ),
        ),
      ],
    );
  }

  Widget _buildHomeScreen() {
    return Consumer<WeatherProvider>(
      builder: (context, state, child) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: context.padding.top),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("End of the list"),
                    Text("Refreshed at ${getRefreshString()}"),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: context.padding.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("End of the list"),
                    Text("Refreshed at ${getRefreshString()}"),
                  ],
                ),
              ),
            ),
            PageView(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              clipBehavior: Clip.none,
              onPageChanged: _onForecastPageChange,
              children: [
                for (int i = 0; i < state.geocodings.length; i++)
                  ForecastCard(
                    geocoding: state.geocodings[i],
                    hour: _hour,
                  )
              ],
            ),
            Positioned.fill(
              right: 6,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.geocodings.length,
                    (index) => _indicator(index, index == _selectedPageIndex),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _indicator(int index, bool isActive) {
    bool isFirst = index == 0;

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
      child: SizedBox(
        height: 16,
        child: Icon(
          isFirst ? Icons.near_me : Icons.circle,
          color: isActive ? Colors.white : Colors.grey.withOpacity(0.8),
          size: isFirst ? 16 : 10,
        ),
      ),
    );
  }
}
