import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:weather/weather/models/forecast.dart';

class WeatherProvider extends ChangeNotifier {
  final PageController _pageController = PageController();
  final List<Forecast> _forecasts = Forecast.sampleData();

  PageController get pageController => _pageController;
  UnmodifiableListView<Forecast> get forecasts =>
      UnmodifiableListView(_forecasts);
}
