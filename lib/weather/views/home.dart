import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/weather/controllers/providers/forecast_card_provider.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, RouteAware {
  late Future<void> _initializationFunction;
  late WeatherProvider _weatherProvider;

  final LocationController locationController = LocationController();
  final ForecastRepo forecastRepo = ForecastRepo();

  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _weatherProvider = context.read<WeatherProvider>();
    _initializationFunction = _weatherProvider.initializeData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _weatherProvider.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _weatherProvider.refreshData();
    }
  }

  String getRefreshString() {
    return DateFormat("HH:mm").format(_weatherProvider.refreshTime);
  }

  @override
  Widget build(BuildContext context) {
    void onStatusBarTap() {
      double pageIndex = _weatherProvider.pageController.page ?? 0;

      if (pageIndex > 0) {
        _weatherProvider.pageController.animateToPage(0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut);
      }
    }

    return Stack(
      children: [
        Scaffold(
          body: FutureBuilder(
            future: _initializationFunction,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                FlutterNativeSplash.remove();
                return _buildHomeScreen();
              } else {
                FlutterNativeSplash.remove();
                return _buildHomeScreen();
              }
            },
          ),
        ),
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
              controller: state.pageController,
              clipBehavior: Clip.none,
              onPageChanged: (page) {
                HapticFeedback.mediumImpact();
                setState(() {
                  _selectedPageIndex = page;
                });
              },
              children: [
                for (int i = 0; i < state.geocodings.length; i++)
                  ChangeNotifierProvider(
                    create: (context) {
                      return ForecastCardProvider(state.geocodings[i]);
                    },
                    child: ForecastCard(geocoding: state.geocodings[i]),
                  ),
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
        Provider.of<WeatherProvider>(context, listen: false)
            .pageController
            .animateToPage(
              index,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 600),
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
