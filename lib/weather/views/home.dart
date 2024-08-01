import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/shared/utilities/providers/drawer_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/shared/views/sliding_drawer.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_card.dart';
import 'package:not_another_weather_app/weather/views/components/weather_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late Future<void> _initialization;

  late DeviceProvider _deviceProvider;
  late WeatherProvider _weatherProvider;
  late DrawerProvider _drawerProvider;

  final LocationController locationController = LocationController();
  final ForecastRepo forecastRepo = ForecastRepo();

  int selectedPageIndex = 0;
  bool isPressingNewLocation = false;
  DateTime refreshDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    _weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    _drawerProvider = Provider.of<DrawerProvider>(context, listen: false);

    Connectivity().onConnectivityChanged.listen((event) {
      _deviceProvider.setHasInternet(!event.contains(ConnectivityResult.none));
    });

    _initialization = initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _deviceProvider.dispose();
    _weatherProvider.dispose();
    _drawerProvider.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (DateTime.now()
          .isAfter(refreshDate.add(const Duration(minutes: 15)))) {
        getData();
      }
    }
  }

  Future<void> initialize() async {
    await getData();
    FlutterNativeSplash.remove();
  }

  Future<void> getData() async {
    await _weatherProvider.initialization();

    refreshDate = DateTime.now();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString("refresh_date", refreshDate.toString());
  }

  String getRefreshString() => DateFormat("HH:mm").format(refreshDate);

  @override
  Widget build(BuildContext context) {
    void onStatusBarTap() {
      if (!_drawerProvider.isOpened &&
          _weatherProvider.pageController.page! > 0) {
        _weatherProvider.pageController.animateToPage(0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut);
      }
    }

    return Stack(
      children: [
        Scaffold(
          body: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return _buildHomeScreen();
              }
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).padding.top,
          child: GestureDetector(
            excludeFromSemantics: true,
            onTap: onStatusBarTap,
          ),
        ),
      ],
    );
  }

  Widget _buildHomeScreen() {
    return SlidingDrawer(
      drawer: const WeatherDrawer(),
      child: Consumer<WeatherProvider>(
        builder: (context, state, child) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
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
                    selectedPageIndex = page;
                  });
                },
                children: [
                  for (int i = 0; i < state.geocodings.length; i++)
                    ChangeNotifierProvider(
                      create: (context) =>
                          CurrentGeocodingProvider(state.geocodings[i]),
                      child: const ForecastCard(),
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
                      (index) => _indicator(index, index == selectedPageIndex),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
