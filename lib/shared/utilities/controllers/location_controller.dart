import 'package:geolocator/geolocator.dart';

class LocationController {
  Future<bool> _isEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> _getPermissions() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> _requestPermissions() async {
    return await Geolocator.requestPermission();
  }

  Future<Position> getCurrentPosition() async {
    var isEnabled = await _isEnabled();
    var permissions = await _getPermissions();

    if (!isEnabled) {
      print("Not enabled!");
    }

    if (permissions == LocationPermission.denied) {
      permissions = await _requestPermissions();

      if (permissions == LocationPermission.denied) {
        print("Location permissions are denied");
      }
    }

    if (permissions == LocationPermission.deniedForever) {
      print(
          "Location permissions are permanently denied, we cannot request permissions");
    }

    return await Geolocator.getCurrentPosition();
  }
}
