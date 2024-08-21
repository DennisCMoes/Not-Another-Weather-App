import 'dart:async';
import 'dart:collection';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/main.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/geocoding_repo.dart';
import 'package:not_another_weather_app/weather/models/dummy_data.dart';
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
  DateTime _currentHour = DateTime.now();

  PageController get pageController => _pageController;
  DateTime get currentHour => _currentHour;

  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  void initializeStoredGeocodings() {
    final List<Geocoding> storedGeocodings =
        _geocodingRepo.getStoredGeocodings();

    // TODO: Remove these lines for builder, now used just for debugging
    final forecasts = _forecastRepo.getAllForecastsFromBox();
    final daily = objectBox.dailyBox.getAll();
    final hourly = objectBox.hourlyBox.getAll();

    if (storedGeocodings.isEmpty) {
      storedGeocodings
          .add(Geocoding(1, "Current location", 0, 0, "Current location")
            ..isCurrentLocation = true
            ..ordening = 0
            ..selectedForecastItems = [
              SelectableForecastFields.windSpeed,
              SelectableForecastFields.precipitation,
              SelectableForecastFields.chainceOfRain,
              SelectableForecastFields.cloudCover,
            ]);
    } else {
      storedGeocodings.sort((a, b) => a.ordening - b.ordening);
    }

    storedGeocodings.firstWhere((geocoding) => geocoding.id == 1)
      ..isCurrentLocation = true
      ..ordening = 0;

    _geocodings = storedGeocodings;
  }

  Future<void> initializeForecastsOfGeocodings() async {
    final completer = Completer<void>();
    _getData(completer);
    return completer.future;
  }

  Future<void> refreshData() async {
    _geocodings = await Future.wait(
      geocodings.map(
        (coding) async {
          if (coding.isTestClass != TestClass.none) {
            return coding;
          }
          return coding;
        },
      ).toList(),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("refresh_date", DateTime.now().toString());
    _currentHour = DateTime.now();

    notifyListeners();
  }

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

  Future<void> _getData(Completer<void> completer) async {
    try {
      // final SharedPreferences prefs = await SharedPreferences.getInstance();

      // prefs.setInt("temperature_unit", 0);
      // prefs.setInt("wind_speed_unit", 0);
      // prefs.setInt("precipitation_unit", 1);

      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (!connectivityResult.contains(ConnectivityResult.none)) {
        final Position position =
            await _locationController.getCurrentPosition();
        final localGeocodingIndex =
            _geocodings.indexWhere((geocode) => geocode.id == 1);

        _geocodings[localGeocodingIndex].latitude = position.latitude;
        _geocodings[localGeocodingIndex].longitude = position.longitude;

        _geocodingRepo.storeGeocoding(_geocodings[localGeocodingIndex]);
      }

      _geocodings = await Future.wait(
        _geocodings.map(
          (coding) async {
            if (coding.isTestClass != TestClass.none) {
              return coding;
            }

            Forecast forecast;

            if (connectivityResult.contains(ConnectivityResult.none)) {
              // TODO: Remove the ! check. Try a normal if else check
              forecast = _forecastRepo.getForecastById(coding.id);
              coding.forecast = forecast;
            } else {
              // Remove all the hourly and daily data from storage
              _forecastRepo.deleteAllDaily(coding.id);
              _forecastRepo.deleteAllHourly(coding.id);

              forecast = await _forecastRepo.getForecastOfLocation(coding);
              forecast.id = coding.id;
              _forecastRepo.storeForecast(forecast);
            }

            coding.forecast = forecast;
            _geocodingRepo.storeGeocoding(coding);
            return coding;
          },
        ).toList(),
      );

      completer.complete();
    } catch (exception, stacktrace) {
      debugPrint("Something went wrong with the _getData: $exception");
      completer.completeError(exception, stacktrace);
    }
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
    // Checks for invalid index
    if (oldIndex < 0 ||
        oldIndex >= _geocodings.length ||
        newIndex < 0 ||
        newIndex >= _geocodings.length) {
      return;
    }

    final oldItem = _geocodings.removeAt(oldIndex);

    _geocodings.insert(newIndex, oldItem);

    for (int i = 0; i < _geocodings.length; i++) {
      _geocodings[i].ordening = i;
    }

    _geocodingRepo.updateGeocodings(_geocodings);
    notifyListeners();
  }

  /// Adds a new geocoding location and fetches it's forecast
  Future<void> addGeocoding(Geocoding geocoding) async {
    geocoding.ordening = _geocodings.length;
    _geocodings.add(geocoding);
    notifyListeners();

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
