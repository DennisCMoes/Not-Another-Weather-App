import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';
import 'package:weather/shared/utilities/providers/device_provider.dart';
import 'package:weather/weather/controllers/repositories/forecast_repo.dart';
import 'package:weather/weather/models/forecast.dart';
import 'package:weather/weather/models/weather_code.dart';
import 'package:weather/weather/views/components/hour_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final LocationController locationController = LocationController();
  final ForecastRepo forecastRepo = ForecastRepo();

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

    print("Current location $data");
    setState(() {
      _localForecast = data;
      _scrollController.jumpTo((75.0 + 8) * (DateTime.now().hour - 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 75,
        title: _localForecast == null
            ? Text("Loading", style: Theme.of(context).textTheme.displayLarge)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_localForecast!.temperature.round()}º",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    _localForecast!.weatherCode.description,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.black45,
                        ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.list,
              size: 24,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Material(
                  color: _localForecast?.weatherCode.color ??
                      Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          height: 200,
                          width: 200,
                          child: Material(
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "${_localForecast?.temperature.round() ?? "XX"}º",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          _localForecast?.weatherCode.description ??
                              WeatherCode.unknown.description,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              weatherDetail(
                                "Wind",
                                "${_localForecast?.windSpeed.round() ?? "XX"}km/h",
                              ),
                              const VerticalDivider(color: Colors.black54),
                              weatherDetail(
                                "Pressure",
                                "${_localForecast?.pressure.round() ?? "XX"} mbar",
                              ),
                              const VerticalDivider(color: Colors.black54),
                              weatherDetail(
                                "Humidity",
                                "${_localForecast?.humidity ?? "XX"}%",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: _localForecast?.hourlyTemperatures.length ?? 0,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) => WeatherHourCard(
                  _localForecast!.hourlyTemperatures.entries.elementAt(index),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addNewLocation(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() => isPressingNewLocation = true),
      onTapUp: (details) => setState(() => isPressingNewLocation = false),
      onTapCancel: () => setState(() => isPressingNewLocation = false),
      child: Transform.scale(
        scale: isPressingNewLocation ? 0.95 : 1,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget weatherDetail(String description, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(description),
      ],
    );
  }
}
