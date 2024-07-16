import 'package:flutter/material.dart';
import 'package:weather/weather/controllers/repositories/forecast_repo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ForecastRepo forecastRepo = ForecastRepo();

  void getData() async {
    print("Getting Data");
    var data = await forecastRepo.getForecast();
    print(data);
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
