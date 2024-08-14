import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:not_another_weather_app/shared/utilities/controllers/location_controller.dart';

class DeviceProvider extends ChangeNotifier {
  final LocationController _locationController = LocationController();

  DateTime _refreshTime = DateTime.now();
  bool _hasInternet = false;
  Position? _currentLocation;

  bool get hasInternet => _hasInternet;
  DateTime get refreshTime => _refreshTime;

  void initialization() async {
    _currentLocation = await _locationController.getCurrentPosition();
    notifyListeners();
  }

  void setRefreshTime([DateTime? time]) {
    _refreshTime = time ?? DateTime.now();
    notifyListeners();
  }

  void setCurrentLocation(Position position) {
    _currentLocation = position;
    notifyListeners();
  }

  Position? getCurrentLocation() {
    return _currentLocation;
  }

  void setHasInternet(bool hasInternet) {
    _hasInternet = hasInternet;
    notifyListeners();
  }
}
