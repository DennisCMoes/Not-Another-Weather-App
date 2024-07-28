import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';

/// A provider class that manages the weather-related data and operations
class WeatherProvider extends ChangeNotifier {
  final ForecastRepo _forecastRepo = ForecastRepo();
  final LocationController _locationController = LocationController();
  final PageController _pageController = PageController();

  final List<Geocoding> _geocodings = [];

  PageController get pageController => _pageController;

  Geocoding get currentLocation => _geocodings[0];

  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  /// Initializes the weather provider by fetching the current location and it's forecasts, and notifying it's listeners.
  Future<void> initialization() async {
    try {
      final Position position = await _locationController.getCurrentPosition();
      final currentLocationGeocoding = Geocoding(1, "My location",
          position.latitude, position.longitude, "My location",
          isCurrentLocation: true);

      _geocodings.add(currentLocationGeocoding);
      notifyListeners();

      currentLocationGeocoding.forecast = await _forecastRepo.getLocalForecast(
          position.latitude, position.longitude);
      notifyListeners();
    } catch (ex) {
      debugPrint("Error during initialization: $ex");
    }
  }

  /// Retrieves the stored geocodings and their forecasts
  Future<void> getStoredGeocodings() async {
    try {
      final List<Geocoding> storedGeocodings = await Future.wait(
        Geocoding.sampleData().map((geo) async {
          final forecast =
              await _forecastRepo.getLocalForecast(geo.latitude, geo.longitude);
          geo.forecast = forecast;
          return geo;
        }).toList(),
      );

      _geocodings.addAll(storedGeocodings);
      notifyListeners();
    } catch (ex) {
      debugPrint("Error getting the stored geocodings: $ex");
    }
  }

  // Moves a geocoding location from [oldIndex] to [newIndex] in the list
  void moveGeocodings(int oldIndex, int newIndex) {
    final item = _geocodings.removeAt(oldIndex);
    _geocodings.insert(newIndex, item);
    notifyListeners();
  }

  /// Adds a new geocoding location and fetches it's forecast
  Future<void> addGeocoding(Geocoding geocoding) async {
    _geocodings.add(geocoding);
    notifyListeners();

    final Forecast forecast = await _forecastRepo.getLocalForecast(
        geocoding.latitude, geocoding.longitude);
    geocoding.forecast = forecast;

    _geocodings[_geocodings.length - 1] = geocoding;
    notifyListeners();
  }

  /// Removes the specified [geocoding] location from the list
  void removeGeocoding(Geocoding geocoding) {
    int geoIndex = _geocodings.indexOf(geocoding);

    if (geoIndex != -1) {
      _geocodings.removeAt(geoIndex);
      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found");
    }
  }
}
