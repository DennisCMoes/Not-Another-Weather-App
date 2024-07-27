import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';
import 'package:not_another_weather_app/weather/controllers/repositories/forecast_repo.dart';
import 'package:not_another_weather_app/weather/models/forecast.dart';
import 'package:not_another_weather_app/weather/models/geocoding.dart';
import 'package:not_another_weather_app/weather/models/widget_item.dart';

class WeatherProvider extends ChangeNotifier {
  final ForecastRepo _forecastRepo = ForecastRepo();
  final LocationController _locationController = LocationController();
  final PageController _pageController = PageController();

  final List<Geocoding> _geocodings = [];

  PageController get pageController => _pageController;

  Geocoding get currentLocation => _geocodings[0];

  UnmodifiableListView<Geocoding> get geocodings =>
      UnmodifiableListView(_geocodings);

  Future<void> initialization() async {
    try {
      final Position position = await _locationController.getCurrentPosition();
      _geocodings.add(Geocoding(1, "My location", position.latitude,
          position.longitude, 'My location',
          isCurrentLocation: true));
      notifyListeners();

      _geocodings[0].forecast = await _forecastRepo.getLocalForecast(
          position.latitude, position.longitude);
      notifyListeners();

      // await getStoredGeocodings();
    } catch (ex) {
      debugPrint("Error during initialization: $ex");
    }
  }

  Future<void> getStoredGeocodings() async {
    try {
      final updatedGeocodings =
          await Future.wait(Geocoding.sampleData().map((geo) async {
        final forecast =
            await _forecastRepo.getLocalForecast(geo.latitude, geo.longitude);

        geo.forecast = forecast;
        return geo;
      }).toList());

      _geocodings.addAll(updatedGeocodings);

      notifyListeners();
    } catch (ex) {
      debugPrint("Error getting the stored geocodings: $ex");
    }
  }

  void moveGeocodings(int oldIndex, int newIndex) {
    final item = _geocodings.removeAt(oldIndex);
    _geocodings.insert(newIndex, item);

    notifyListeners();
  }

  void changeSelectedMainField(
      Geocoding selectedGeocoding, SelectableForecastFields field) {
    int index = _geocodings.indexOf(selectedGeocoding);

    if (index != -1) {
      _geocodings[index].selectedMainField = field;
      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found.");
    }
  }

  void replaceSelectedForecastItem(
      Geocoding selectedGeocoding, SelectableForecastFields field, int index) {
    int geoIndex = _geocodings.indexOf(selectedGeocoding);

    if (geoIndex != -1 && index != -1) {
      _geocodings[geoIndex].selectedForecastItems[index] = field;
      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found.");
    }
  }

  void changeSelectedPage(Geocoding selectedGeocoding, int index) {
    int geoIndex = _geocodings.indexOf(selectedGeocoding);

    if (geoIndex != -1 && index != -1) {
      _geocodings[geoIndex].selectedPage = index;
      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found.");
    }
  }

  Future<void> addGeocoding(Geocoding geocoding) async {
    _geocodings.add(geocoding);
    notifyListeners();

    final Forecast forecast = await _forecastRepo.getLocalForecast(
        geocoding.latitude, geocoding.longitude);
    geocoding.forecast = forecast;

    _geocodings[_geocodings.length - 1] = geocoding;
    notifyListeners();
  }

  void removeGeocoding(Geocoding geocoding) {
    int geoIndex = _geocodings.indexOf(geocoding);

    if (geoIndex != -1) {
      _geocodings.removeAt(geoIndex);
      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found");
    }
  }

  void changeGeocodingSize(
      Geocoding geocoding, WidgetItem item, WidgetSize size) {
    int geoIndex = _geocodings.indexOf(geocoding);

    if (geoIndex != -1) {
      _geocodings[geoIndex]
          .detailWidgets
          .singleWhere((element) => element.id == item.id)
          .size = size;

      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found");
    }
  }

  void changeGeocodingType(
      Geocoding geocoding, WidgetItem item, WidgetType type) {
    int geoIndex = _geocodings.indexOf(geocoding);

    if (geoIndex != -1) {
      _geocodings[geoIndex]
          .detailWidgets
          .singleWhere((element) => element.id == item.id)
          .type = type;

      notifyListeners();
    } else {
      debugPrint("Error: Geocoding not found");
    }
  }
}
