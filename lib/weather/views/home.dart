import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:not_another_weather_app/shared/extensions/context_extensions.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/shared/utilities/providers/drawer_provider.dart';
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
  late Future<void> _initializationBuilder;

  late DeviceProvider _deviceProvider;
  late WeatherProvider _weatherProvider;
  late DrawerProvider _drawerProvider;

  final LocationController locationController = LocationController();
  final ForecastRepo forecastRepo = ForecastRepo();

  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _deviceProvider = context.read<DeviceProvider>();
    _weatherProvider = context.read<WeatherProvider>();
    _drawerProvider = context.read<DrawerProvider>();

    Connectivity().onConnectivityChanged.listen((event) {
      _deviceProvider.setHasInternet(!event.contains(ConnectivityResult.none));
    });

    _initializationBuilder = _initialize();
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
      _refreshData();
    }
  }

  String getRefreshString() {
    return DateFormat("HH:mm").format(_deviceProvider.refreshTime);
  }

  Future<void> _initialize() async {
    await _weatherProvider.initialization();
    FlutterNativeSplash.remove();
  }

  Future<void> _refreshData() async {
    bool shouldRefresh = DateTime.now()
        .isAfter(_deviceProvider.refreshTime.add(const Duration(minutes: 15)));

    if (shouldRefresh) {
      await _weatherProvider.refreshData();
      _deviceProvider.setRefreshTime();
    }
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
            future: _initializationBuilder,
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
                    create: (context) => ForecastCardProvider(
                      state.geocodings[i],
                    ),
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
