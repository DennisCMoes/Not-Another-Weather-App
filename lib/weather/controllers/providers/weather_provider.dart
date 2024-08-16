import 'dart:collection';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/logics/selectable_forecast_fields.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class that manages the weather-related data and operations
class WeatherProvider extends ChangeNotifier {
  final ForecastRepo _forecastRepo = ForecastRepo();
  final GeocodingRepo _geocodingRepo = GeocodingRepo();
  final LocationController _locationController = LocationController();
  final PageController _pageController = PageController();

  List<Geocoding> _geocodings = [];

  PageController get pageController => _pageController;

  Geocoding get currentLocation => _geocodings[0];

  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  /// Initializes the weather provider by fetching the current location and it's forecasts, and notifying it's listeners.
  Future<void> initialization() async {
    try {
      // Check network connectivity
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      final List<Geocoding> localGeocodings =
          _geocodingRepo.getStoredGeocodings();

      if (localGeocodings.isEmpty) {
        Geocoding geocoding =
            Geocoding(1, "Current location", 0, 0, "Current location");

        geocoding.selectedForecastItems = [
          SelectableForecastFields.windSpeed,
          SelectableForecastFields.precipitation,
          SelectableForecastFields.chainceOfRain,
          SelectableForecastFields.cloudCover,
        ];
        localGeocodings.add(geocoding);
      }

      final Geocoding localGeocoding =
          localGeocodings.firstWhere((geocoding) => geocoding.id == 1);
      localGeocoding.isCurrentLocation = true;

      // If there is network connectivity refresh and store local geocoding data
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        final Position position =
            await _locationController.getCurrentPosition();

        localGeocoding.latitude = position.latitude;
        localGeocoding.longitude = position.longitude;

        _geocodingRepo.storeGeocoding(localGeocoding);
      }

      _geocodings.addAll(localGeocodings);
      await refreshData();
    } catch (exception, stacktrace) {
      debugPrint("Error during initialization: $exception");
      await Sentry.captureException(exception, stackTrace: stacktrace);

      rethrow;
    }
  }

  Future<void> refreshData() async {
    _geocodings = await Future.wait(
      geocodings.map(
        (coding) async {
          Forecast forecast = await _forecastRepo.getForecastOfLocation(
            coding.latitude,
            coding.longitude,
          );

          coding.forecast = forecast;
          return coding;
        },
      ).toList(),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("refresh_date", DateTime.now().toString());

    notifyListeners();
  }

  int getIndexOfGeocoding(Geocoding geocoding) {
    return _geocodings.indexWhere((geo) => geo.id == geocoding.id);
  }

  bool isAlreadyPresent(Geocoding geocoding) {
    return _geocodings.any((geo) => geo.id == geocoding.id);
  }

  Geocoding getGeocoding(int id) {
    return _geocodings.firstWhere((geo) => geo.id == id);
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

    final Forecast forecast = await _forecastRepo.getForecastOfLocation(
        geocoding.latitude, geocoding.longitude);
    geocoding.forecast = forecast;

    _geocodings[_geocodings.length - 1] = geocoding;
    _geocodingRepo.storeGeocoding(geocoding);
    notifyListeners();
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
