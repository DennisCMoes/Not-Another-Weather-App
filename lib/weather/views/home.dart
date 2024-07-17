import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';
import 'package:weather/shared/utilities/providers/device_provider.dart';
import 'package:weather/weather/controllers/repositories/forecast_repo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ForecastRepo forecastRepo = ForecastRepo();
  LocationController locationController = LocationController();

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
    // initialization();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Hello!"),
              TextButton(
                onPressed: getData,
                child: const Text("Get Data"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
