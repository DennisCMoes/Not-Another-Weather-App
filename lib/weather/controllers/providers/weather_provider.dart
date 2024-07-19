import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:weather/weather/models/forecast.dart';
import 'package:weather/weather/models/geocoding.dart';

class WeatherProvider extends ChangeNotifier {
  final PageController _pageController = PageController();
  final List<Forecast> _forecasts = Forecast.sampleData();
  final List<Geocoding> _geocodings = Geocoding.sampleData();

  PageController get pageController => _pageController;

  UnmodifiableListView<Forecast> get forecasts =>
      UnmodifiableListView(_forecasts);
  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);
}
