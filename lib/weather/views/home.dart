import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:not_another_weather_app/shared/utilities/providers/device_provider.dart';
import 'package:not_another_weather_app/weather/controllers/providers/current_geocoding_provider.dart';
import 'package:provider/provider.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/shared/views/sliding_drawer.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/views/components/forecast_card.dart';
import 'package:not_another_weather_app/weather/views/components/weather_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _initialization;

  final LocationController locationController = LocationController();
  final ForecastRepo forecastRepo = ForecastRepo();

  int selectedPageIndex = 0;
  bool isPressingNewLocation = false;

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((event) {
      print(event);
      Provider.of<DeviceProvider>(context, listen: false)
          .setHasInternet(!event.contains(ConnectivityResult.none));
    });

    _initialization = initialize();
  }

  Future<void> initialize() async {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.initialization();
    // await weatherProvider.getStoredGeocodings();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      WeatherProvider provider =
          Provider.of<WeatherProvider>(context, listen: false);
      PageController? pageController = provider.pageController;

      int pageIndex = 0;

      if (pageController.positions.isNotEmpty) {
        pageIndex = pageController.page?.toInt() ?? 0;
      }

      if (provider.geocodings.isEmpty) {
        return Colors.blueGrey;
      } else {
        return provider.geocodings[pageIndex].forecast?.weatherCode.colorScheme
                .mainColor ??
            Colors.blueGrey;
      }
    }

    return Scaffold(
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
                  child: const Text("End of the list"),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: const Text("End of the list"),
                ),
              ),
              PageView(
                scrollDirection: Axis.vertical,
                controller: state.pageController,
                clipBehavior: Clip.none,
                onPageChanged: (page) {
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
              )
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
