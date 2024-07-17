import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';
import 'package:weather/shared/utilities/providers/device_provider.dart';
import 'package:weather/weather/controllers/repositories/forecast_repo.dart';
import 'package:weather/weather/models/forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ForecastRepo forecastRepo = ForecastRepo();
  LocationController locationController = LocationController();
  Forecast? _localForecast;

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

  void getData() async {
    print("Getting Data");
    var data = await forecastRepo.getForecast();
    print(data);
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
                  Text("${_localForecast!.temperature.round()}º",
                      style: Theme.of(context).textTheme.displayLarge),
                  Text(_localForecast!.weatherCode.description,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Colors.black45)),
                ],
              ),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 9 / 12,
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        color: _localForecast?.weatherCode.color ??
                            Colors.blue.withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              const Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Material(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    weatherDetail(
                                      "Wind",
                                      "${_localForecast?.windSpeed.round() ?? "XX"}km/h",
                                    ),
                                    const VerticalDivider(),
                                    weatherDetail(
                                      "Pressure",
                                      "${_localForecast?.pressure.round() ?? "XX"} mbar",
                                    ),
                                    const VerticalDivider(),
                                    weatherDetail(
                                      "Humidity",
                                      "${_localForecast?.humidity ?? "XX"}%",
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
