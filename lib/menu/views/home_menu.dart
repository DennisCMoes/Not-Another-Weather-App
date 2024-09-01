import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/controllers/providers/weather_provider.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/views/home.dart';
import 'package:provider/provider.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  late WeatherProvider _weatherProvider;

  @override
  void initState() {
    super.initState();

    _weatherProvider = context.read<WeatherProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Menu")),
      body: Consumer<WeatherProvider>(
        builder: (context, state, child) {
          return ListView.separated(
            itemCount: state.geocodings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _geocodingCard(state.geocodings[index], index),
          );
        },
      ),
    );
  }

  Widget _geocodingCard(Geocoding geocoding, int index) {
    void onClick() {
      print("Clicked on ${geocoding.name}");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: WeatherProvider(index),
            child: HomeScreen(initialPageIndex: index),
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.card,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(geocoding.name),
          ),
        ),
      ),
    );
  }
}
