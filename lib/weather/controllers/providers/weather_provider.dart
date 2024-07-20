import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';
import 'package:weather/weather/controllers/repositories/forecast_repo.dart';
import 'package:weather/weather/models/forecast.dart';
import 'package:weather/weather/models/geocoding.dart';

class WeatherProvider extends ChangeNotifier {
  final ForecastRepo _forecastRepo = ForecastRepo();
  final LocationController _locationController = LocationController();
  final PageController _pageController = PageController();
  final List<Forecast> _forecasts = Forecast.sampleData();

  List<Geocoding> _geocodings = [];

  PageController get pageController => _pageController;

  UnmodifiableListView<Forecast> get forecasts =>
      UnmodifiableListView(_forecasts);
  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  Future<void> initialization() async {
    Position position = await _locationController.getCurrentPosition();
    Geocoding current = Geocoding(
      1,
      "My location",
      position.latitude,
      position.longitude,
      'My location',
    );

    _geocodings.addAll([current, ...Geocoding.sampleData()]);
    notifyListeners();
  }

  Future<void> updateGeocodingsWithForecasts() async {
    _geocodings = await Future.wait(_geocodings.map((geo) async {
      Forecast forecast =
          await _forecastRepo.getLocalForecast(geo.latitude, geo.longitude);
      geo.forecast = forecast;

      return geo;
    }).toList());

    notifyListeners();
  }

  void moveGeocodings(int oldIndex, int newIndex) {
    final item = _geocodings.removeAt(oldIndex);
    _geocodings.insert(newIndex, item);

    notifyListeners();
  }
}
