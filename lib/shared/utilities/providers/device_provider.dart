import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/shared/utilities/controllers/location_controller.dart';

class DeviceProvider extends ChangeNotifier {
  final LocationController _locationController = LocationController();

  Position? _currentLocation;

  DeviceProvider() {
    initialization();
  }

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
