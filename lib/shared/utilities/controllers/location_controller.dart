import 'package:geolocator/geolocator.dart';

class LocationController {
  Future<LocationPermission> getLocationPermissions() async {
    return await Geolocator.checkPermission();
  }

  Future<void> askForPermissions() async {
    var isEnabled = await Geolocator.isLocationServiceEnabled();
    var permissions = await getLocationPermissions();

    if (!isEnabled) {
      print("Location services are not enabled!");
    }

    if (permissions == LocationPermission.denied) {
      permissions = await Geolocator.requestPermission();

      if (permissions == LocationPermission.denied) {
        print("Location permissions are denied");
      }
    } else if (permissions == LocationPermission.deniedForever) {
      print(
          "Location permissions are permenantly denied, we cannot request permissions");
    }
  }

  Future<Position> getCurrentPosition() async {
    await askForPermissions();
    return await Geolocator.getCurrentPosition();
  }
}
