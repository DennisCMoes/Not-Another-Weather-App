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
  final List<Geocoding> _geocodings = [];

  PageController get pageController => _pageController;

  UnmodifiableListView<Forecast> get forecasts =>
      UnmodifiableListView(_forecasts);
  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  void initialization() async {
    Position position = await _locationController.getCurrentPosition();
    Geocoding current = Geocoding(
      1,
      "My location",
      position.latitude,
      position.longitude,
      'My location',
    );

    Forecast forecast = await _forecastRepo.getLocalForecast(
        position.latitude, position.longitude);
    current.forecast = forecast;

    _geocodings.add(current);
    _geocodings.addAll(Geocoding.sampleData());
    notifyListeners();
  }
}
