import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';
import 'package:weather/shared/utilities/providers/device_provider.dart';
import 'package:weather/shared/views/sliding_drawer.dart';
import 'package:weather/weather/controllers/repositories/forecast_repo.dart';
import 'package:weather/weather/models/forecast.dart';
import 'package:weather/weather/views/components/forecast_card.dart';
import 'package:weather/weather/views/components/weather_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final LocationController locationController = LocationController();
  final ForecastRepo forecastRepo = ForecastRepo();

  int selectedPageIndex = 0;

  Forecast? _localForecast;
  bool isPressingNewLocation = false;

  @override
  void initState() {
    super.initState();

    DeviceProvider provider =
        Provider.of<DeviceProvider>(context, listen: false);

    provider.addListener(() {
      if (provider.getCurrentLocation() != null) {
        getCurrentPosition();
      }
    });

    if (provider.getCurrentLocation() != null) {
      getCurrentPosition();
    }
  }

  void getCurrentPosition() async {
    Position position = Provider.of<DeviceProvider>(context, listen: false)
        .getCurrentLocation()!;

    var data = await forecastRepo.getLocalForecast(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _localForecast = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingDrawer(
        // drawer: const Text("Hello"),
        drawer: const WeatherDrawer(),
        child: Stack(
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
            PageView.builder(
              itemCount: 4,
              scrollDirection: Axis.vertical,
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  selectedPageIndex = page;
                });
              },
              itemBuilder: (context, index) => ForecastCard(_localForecast),
            ),
            Positioned.fill(
              right: 6,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => _indicator(index, index == selectedPageIndex),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _indicator(int index, bool isActive) {
    bool isFirst = index == 0;

    return SizedBox(
      height: 16,
      child: Icon(
        isFirst ? Icons.near_me : Icons.circle,
        color: isActive ? Colors.green : Colors.red,
        size: isFirst ? 16 : 10,
      ),
    );
  }
}
