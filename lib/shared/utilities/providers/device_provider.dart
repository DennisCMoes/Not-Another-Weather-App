import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';

class DeviceProvider extends ChangeNotifier {
  final LocationController _locationController = LocationController();

  Position? _currentLocation;

  void initialization() async {
    _currentLocation = await _locationController.getCurrentPosition();
    notifyListeners();
  }

  void setCurrentLocation(Position position) {
    _currentLocation = position;
    notifyListeners();
  }

  Position? getCurrentLocation() {
    return _currentLocation;
  }
}
