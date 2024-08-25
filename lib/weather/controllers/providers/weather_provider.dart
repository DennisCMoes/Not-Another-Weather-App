import 'dart:async';
import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/dummy_data.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A provider class that manages the weather-related data and operations
class WeatherProvider extends ChangeNotifier {
  final ForecastRepo _forecastRepo = ForecastRepo();
  final GeocodingRepo _geocodingRepo = GeocodingRepo();
  final PageController _pageController = PageController();

  List<Geocoding> _geocodings = [];
  DateTime _currentHour = DateTime.now();

  PageController get pageController => _pageController;
  DateTime get currentHour => _currentHour;

  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  // Initializes data asynchronously
  Future<void> initializeData() async {
    try {
      await _initializeGeocodingsAndForecasts();
    } catch (exception, stacktrace) {
      debugPrint("Error initializing data: $exception");
      Sentry.captureException(exception, stackTrace: stacktrace);
      rethrow;
    }
  }

  /// Initializes geocodings and forecasts together
  Future<void> _initializeGeocodingsAndForecasts() async {
    _geocodings = _getStoredGeocodings();

    // Fetch and update all forecasts
    await _updateForecasts();
  }

  /// Fetches stored geocodings from the repository and initializes if empty
  List<Geocoding> _getStoredGeocodings() {
    List<Geocoding> storedGeocodings = _geocodingRepo.getStoredGeocodings();

    if (storedGeocodings.isEmpty) {
      storedGeocodings
          .add(Geocoding(1, "Current location", 0, 0, "Current location")
            ..isCurrentLocation = true
            ..ordening = 0
            ..forecast = Forecast.isLoadingData()
            ..selectedForecastItems = [
              SelectableForecastFields.windSpeed,
              SelectableForecastFields.precipitation,
              SelectableForecastFields.chainceOfRain,
              SelectableForecastFields.cloudCover
            ]);
    } else {
      storedGeocodings.sort((a, b) => a.ordening - b.ordening);
    }

    return storedGeocodings;
  }

  // Updates the forecasts for all geocodings asynchronously
  Future<void> _updateForecasts() async {
    _geocodings = await Future.wait(_geocodings.map((geocode) async {
      geocode.forecast = await _forecastRepo.getForecastById(geocode);
      return geocode;
    }).toList());
  }

  /// Adds dummy data to the geocodings list
  void addDummyData() {
    _geocodings.removeWhere((element) => element.isTestClass != TestClass.none);
    _geocodings.addAll([
      DummyData.colorSchemeGeocoding(TestClass.day),
      DummyData.colorSchemeGeocoding(TestClass.night),
      DummyData.clipperGeocoding(TestClass.day),
      DummyData.clipperGeocoding(TestClass.night),
    ]);

    notifyListeners();
  }

  /// Retrieves a specific geocoding by its ID
  Geocoding getGeocoding(int id) {
    return _geocodings.firstWhere((geo) => geo.id == id);
  }

  // Moves a geocoding location from [oldIndex] to [newIndex] in the list
  void moveGeocodings(int oldIndex, int newIndex) {
    // Checks for invalid index
    if (_isValidIndex(oldIndex) && _isValidIndex(newIndex)) {
      final oldItem = _geocodings.removeAt(oldIndex);
      _geocodings.insert(newIndex, oldItem);

      for (int i = 0; i < _geocodings.length; i++) {
        _geocodings[i].ordening = i;
      }

      _geocodingRepo.updateGeocodings(_geocodings);
      notifyListeners();
    }
  }

  /// Chekcs if the provided index is valid within the geocodings list
  bool _isValidIndex(int index) {
    return index >= 0 && index < _geocodings.length;
  }

  /// Removes the specified [geocoding] location from the list
  void removeGeocoding(Geocoding geocoding) {
    int geoIndex = _geocodings.indexOf(geocoding);

    if (geoIndex != -1) {
      _geocodings.removeAt(geoIndex);
      _geocodingRepo.removeGeocoding(geocoding.id);
      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found");
    }
  }
}
