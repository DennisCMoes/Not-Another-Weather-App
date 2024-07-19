import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';
import 'package:weather/shared/utilities/providers/device_provider.dart';
import 'package:weather/shared/views/sliding_drawer.dart';
import 'package:weather/weather/controllers/providers/weather_provider.dart';
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
        drawer: const WeatherDrawer(),
        child: Consumer<WeatherProvider>(
          builder: (context, state, child) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
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
                  itemCount: state.geocodings.length,
                  scrollDirection: Axis.vertical,
                  controller: state.pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      selectedPageIndex = page;
                    });
                  },
                  itemBuilder: (context, index) =>
                      ForecastCard(state.geocodings[index]),
                ),
                Positioned.fill(
                  right: 6,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        state.geocodings.length,
                        (index) =>
                            _indicator(index, index == selectedPageIndex),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
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
